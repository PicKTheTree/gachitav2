// auth_provider.dart
// Firebase Authentication과 Firebase 서비스를 사용하여 사용자 인증, 상태 관리, 데이터 캐싱 및 오류 처리 기능을 제공하는 Flutter Provider 클래스

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../providers/mileage_provider.dart';

/// 사용자 인증 및 관련 데이터를 관리하는 Provider 클래스
/// Firebase Authentication 및 Firebase 관련 서비스를 활용.
class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication 인스턴스
  final FirebaseService _firebaseService = FirebaseService(); // Firebase 관련 커스텀 서비스
  UserModel? _user; // 현재 로그인된 사용자 정보
  Map<String, String> _userEmails = {}; // 캐싱된 사용자 이메일 정보

  /// 현재 로그인된 사용자 정보를 반환
  UserModel? get user => _user;

  /// 사용자 로그인 처리 메서드
  /// - [email]: 사용자 이메일
  /// - [password]: 사용자 비밀번호
  /// - [mileageProvider]: 마일리지 초기화 및 관리 제공자
  Future<void> signIn(
      String email, String password, MileageProvider mileageProvider) async {
    try {
      // Firebase Authentication을 이용한 이메일/비밀번호 로그인
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Firebase에서 사용자 데이터를 가져옴
        _user = await _firebaseService.getUserData(userCredential.user!.uid);
        
        if (_user != null) {
          // 사용자 데이터가 존재할 경우 마일리지 초기화
          await mileageProvider.initializeUserMileage();
          notifyListeners(); // UI에 상태 변화 알림
        } else {
          // 사용자 데이터를 가져오지 못한 경우 예외 처리
          throw '사용자 정보를 불러올 수 없습니다.';
        }
      }
    } catch (e) {
      print('Login error: $e'); // 디버깅을 위한 오류 로그

      // Firebase 서버가 503 상태를 반환한 경우 재시도 로직
      if (e.toString().contains('503')) {
        await Future.delayed(Duration(seconds: 2)); // 2초 대기 후 재시도

        try {
          // 재시도 로그인 요청
          final UserCredential userCredential = 
              await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          
          if (userCredential.user != null) {
            // 사용자 데이터를 다시 가져옴
            _user = await _firebaseService.getUserData(userCredential.user!.uid);
            
            if (_user != null) {
              // 성공적으로 데이터가 로드된 경우
              await mileageProvider.initializeUserMileage();
              notifyListeners();
            }
          }
        } catch (retryError) {
          // 재시도 실패 시 사용자에게 안내 메시지
          throw '서버 연결에 실패했습니다. 잠시 후 다시 시도해주세요.';
        }
      } else {
        // 다른 모든 에러는 그대로 전달
        throw e.toString();
      }
    }
  }

  /// 사용자 로그아웃 처리 메서드
  Future<void> signOut() async {
    await _firebaseService.signOut(); // Firebase 로그아웃 처리
    _user = null; // 사용자 데이터 초기화
    notifyListeners(); // UI에 상태 변화 알림
  }

  /// 특정 사용자 ID로 사용자 이름 가져오기
  /// - [userId]: 사용자 ID
  Future<String> getUserName(String userId) async {
    return await _firebaseService.getUserName(userId);
  }

  /// 특정 사용자 UID로 이메일 가져오기
  /// - [uid]: 사용자 UID
  Future<String?> getUserEmail(String uid) async {
    if (user?.uid == uid) {
      return user?.email; // 현재 로그인된 사용자의 이메일 반환
    }

    if (_userEmails.containsKey(uid)) {
      return _userEmails[uid]; // 캐싱된 이메일 반환
    }

    try {
      // Firebase에서 사용자 이메일 가져오기
      String? email = await _firebaseService.getUserEmail(uid);
      
      if (email != null) {
        _userEmails[uid] = email; // 가져온 이메일 캐싱
      }
      return email;
    } catch (e) {
      print('Error getting user email: $e'); // 오류 로그
      return null; // 실패 시 null 반환
    }
  }
}

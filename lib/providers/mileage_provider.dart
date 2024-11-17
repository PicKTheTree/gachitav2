import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 마일리지 시스템을 관리하는 Provider 클래스
/// - 사용자 마일리지 조회, 충전, 차감 기능 제공
class MileageProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase 인증 인스턴스

  int _currentMileage = 0; // 현재 사용자 마일리지 상태

  /// 현재 마일리지를 반환하는 Getter
  int get currentMileage => _currentMileage;

  /// 초기 마일리지 설정 또는 기존 마일리지 불러오기
  Future<void> initializeUserMileage() async {
    User? user = _auth.currentUser; // 현재 로그인된 사용자
    if (user != null) {
      // Firestore에서 사용자 문서를 가져옴
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        // 새 사용자일 경우 초기 마일리지 5000 설정
        await _firestore.collection('users').doc(user.uid).set({
          'mileage': 5000,
        });
        _currentMileage = 5000; // 로컬 상태 업데이트
      } else {
        // 기존 사용자의 마일리지 불러오기
        _currentMileage = userDoc['mileage'] ?? 0;
      }
      notifyListeners(); // UI 업데이트 요청
    }
  }

  /// 현재 마일리지 정보를 Firestore에서 새로 가져오기
  Future<void> fetchCurrentMileage() async {
    User? user = _auth.currentUser; // 현재 사용자 확인
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        // Firestore에서 마일리지 값 가져오기
        _currentMileage = userDoc['mileage'] ?? 0;
        notifyListeners(); // UI 업데이트 요청
      }
    }
  }

  /// 마일리지 충전 기능
  /// - [amount]: 충전할 마일리지 양
  Future<void> rechargeMileage(int amount) async {
    User? user = _auth.currentUser; // 현재 사용자 확인
    if (user != null) {
      // Firestore 트랜잭션을 사용하여 마일리지 업데이트
      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          int currentMileage = userSnapshot['mileage'] ?? 0; // 현재 마일리지
          int newMileage = currentMileage + amount; // 새로운 마일리지 계산

          transaction.update(userRef, {'mileage': newMileage}); // Firestore 업데이트
          _currentMileage = newMileage; // 로컬 상태 업데이트
        }
      });

      notifyListeners(); // UI 업데이트 요청
    }
  }

  /// 마일리지 차감 기능
  /// - [amount]: 차감할 마일리지 양
  /// - 반환 값: 성공 여부 (bool)
  Future<bool> deductMileage(int amount) async {
    User? user = _auth.currentUser; // 현재 사용자 확인
    if (user != null) {
      bool success = false; // 차감 성공 여부

      // Firestore 트랜잭션을 사용하여 마일리지 차감
      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          int currentMileage = userSnapshot['mileage'] ?? 0; // 현재 마일리지
          if (currentMileage >= amount) {
            // 차감 가능 여부 확인
            int newMileage = currentMileage - amount; // 새로운 마일리지 계산
            transaction.update(userRef, {'mileage': newMileage}); // Firestore 업데이트
            _currentMileage = newMileage; // 로컬 상태 업데이트
            success = true; // 차감 성공
          }
        }
      });

      notifyListeners(); // UI 업데이트 요청
      return success; // 결과 반환
    }
    return false; // 사용자 인증되지 않은 경우 실패 반환
  }
}

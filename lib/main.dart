import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './providers/auth_provider.dart' as app_auth;
import './providers/mileage_provider.dart';
import './providers/room_provider.dart';
import './screens/login_screen.dart';
import './screens/new_main_screen.dart';

/// 메인 함수
/// - 앱 실행 전 Firebase 초기화
/// - Flutter 애플리케이션 실행
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진과 위젯 바인딩 초기화
  await Firebase.initializeApp(); // Firebase 초기화
  runApp(MyApp()); // MyApp 실행
}

/// MyApp 클래스
/// - 앱의 최상위 위젯으로 여러 Provider를 등록하고 MaterialApp을 구성
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // 앱 전역에서 사용될 Provider 목록
      providers: [
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()), // 사용자 인증 관리
        ChangeNotifierProvider(create: (_) => MileageProvider()), // 마일리지 관리
        ChangeNotifierProvider(create: (_) => RoomProvider()), // 방 데이터 관리
      ],
      child: MaterialApp(
        title: '같이TA', // 앱 이름
        theme: ThemeData(
          primaryColor: Color(0xFF4A55A2), // 앱의 기본 색상
          scaffoldBackgroundColor: Colors.white, // 기본 배경색
          fontFamily: 'Pretendard', // 앱 전역에서 사용할 기본 글꼴
        ),
        home: LoginScreen(), // 앱 실행 시 가장 먼저 보여지는 화면
      ),
    );
  }
}

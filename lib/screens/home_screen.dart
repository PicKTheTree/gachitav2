import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

/// HomeScreen 클래스
/// - 앱의 메인 화면 역할
/// - 초기 상태에서 환영 메시지와 로그인 화면으로 이동 버튼 제공
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // AuthProvider 인스턴스를 가져옴
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white, // 화면 배경 색상
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경 색상
        elevation: 0, // 그림자 제거
        title: Text(
          '같이TA', // AppBar 제목
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Pretendard', // 사용자 정의 폰트
            fontWeight: FontWeight.w700, // 굵은 글꼴
            color: Color(0xFF4A55A2), // 텍스트 색상
          ),
        ),
        centerTitle: true, // 제목을 중앙 정렬
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24), // 좌우 여백
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
                  crossAxisAlignment: CrossAxisAlignment.center, // 가로 중앙 정렬
                  children: [
                    Container(
                      width: double.infinity, // 컨테이너 너비를 화면 전체로 설정
                      alignment: Alignment.center, // 중앙 정렬
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/symbol.png', // 심볼 이미지
                            width: 200, // 이미지 너비
                            height: 200, // 이미지 높이
                          ),
                          SizedBox(height: 40), // 위젯 간의 간격
                          Text(
                            '환영합니다!', // 환영 메시지
                            textAlign: TextAlign.center, // 텍스트 중앙 정렬
                            style: TextStyle(
                              fontSize: 28, // 텍스트 크기
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              color: Colors.black87, // 텍스트 색상
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '서비스 이용을 위해 로그인해 주세요', // 안내 메시지
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 32),
                          Container(
                            width: double.infinity, // 버튼 너비를 화면 전체로 설정
                            height: 56, // 버튼 높이
                            child: ElevatedButton(
                              onPressed: () {
                                // 로그인 화면으로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4A55A2), // 버튼 배경색
                                foregroundColor: Colors.white, // 텍스트 색상
                                elevation: 0, // 버튼 그림자 제거
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), // 둥근 모서리
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                                children: [
                                  Text(
                                    '로그인하기', // 버튼 텍스트
                                    style: TextStyle(
                                      fontSize: 17, // 텍스트 크기
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.3, // 글자 간격 조정
                                    ),
                                  ),
                                  SizedBox(width: 8), // 텍스트와 아이콘 간격
                                  Icon(
                                    Icons.arrow_forward_ios_rounded, // 아이콘
                                    size: 16, // 아이콘 크기
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 150), // 아래 텍스트와의 간격
                          Text(
                            'made by Software', // 하단 메시지
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'WAGURI', // 커스텀 폰트
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

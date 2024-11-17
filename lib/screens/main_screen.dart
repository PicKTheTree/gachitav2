import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import './room_list_screen.dart';

/// MainScreen 클래스
/// - 앱의 주요 진입점 중 하나로, 환영 메시지와 "방 찾아보기" 버튼을 제공
/// - RoomListScreen으로 이동하여 방을 탐색할 수 있도록 구성
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 화면 배경색 설정
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색
        elevation: 0, // AppBar 그림자 제거
        title: Text(
          '같이TA', // AppBar 제목
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Pretendard', // 커스텀 폰트 사용
            fontWeight: FontWeight.w700, // 굵은 글꼴 스타일
            color: Color(0xFF4A55A2), // 텍스트 색상
          ),
        ),
        centerTitle: true, // AppBar 제목을 중앙 정렬
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24), // 좌우 여백 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯을 수평으로 확장
            children: [
              // 앱의 심볼 이미지를 표시
              Image.asset(
                'assets/symbol.png',
                width: 200, // 이미지 너비
                height: 200, // 이미지 높이
              ),
              SizedBox(height: 40), // 간격 추가
              // 환영 메시지 텍스트
              Text(
                '환영합니다!',
                textAlign: TextAlign.center, // 텍스트 중앙 정렬
                style: TextStyle(
                  fontSize: 28, // 텍스트 크기
                  fontFamily: 'Pretendard', // 폰트 설정
                  fontWeight: FontWeight.w700, // 굵은 글꼴 스타일
                  color: Colors.black87, // 텍스트 색상
                ),
              ),
              SizedBox(height: 12), // 간격 추가
              // 방 탐색 안내 메시지
              Text(
                '방을 찾아보세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // 텍스트 크기
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400, // 보통 두께
                  color: Colors.black54, // 연한 텍스트 색상
                ),
              ),
              SizedBox(height: 32), // 간격 추가
              // 방 찾기 버튼
              ElevatedButton(
                onPressed: () {
                  // RoomListScreen으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => RoomProvider(), // RoomProvider 생성
                        child: RoomListScreen(), // RoomListScreen을 자식으로 설정
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18), // 버튼 내부 여백
                  backgroundColor: Color(0xFF4A55A2), // 버튼 배경색
                  foregroundColor: Colors.white, // 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // 버튼의 둥근 모서리
                  ),
                  elevation: 0, // 버튼 그림자 제거
                  minimumSize: Size(double.infinity, 60), // 버튼 크기 설정
                ),
                child: Text(
                  '방 찾아보기', // 버튼 텍스트
                  style: TextStyle(
                    fontSize: 18, // 텍스트 크기
                    fontFamily: 'Pretendard', // 폰트 설정
                    fontWeight: FontWeight.w600, // 굵은 글꼴
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

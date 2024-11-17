import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/mileage_provider.dart';
import '../models/user_model.dart';
import 'mileage_recharge_screen.dart';
import 'room_list_screen.dart';

/// NewMainScreen 클래스
/// - 사용자 마일리지 상태를 확인하여 적절한 화면을 제공
/// - 마일리지 충전 및 방 탐색 기능 제공
/// - 방 탐색 화면으로 이동 시 경로 안내 팝업을 표시
class NewMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // 사용자 인증 상태 제공
    final mileageProvider = Provider.of<MileageProvider>(context); // 마일리지 상태 제공
    final UserModel? user = authProvider.user; // 현재 로그인된 사용자 정보

    // 로그인되지 않은 경우 기본 화면
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return WillPopScope(
      onWillPop: () async => false, // 뒤로가기 비활성화
      child: Scaffold(
        backgroundColor: Colors.white, // 기본 배경색
        appBar: AppBar(
          automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 비활성화
          backgroundColor: Colors.white, // AppBar 배경색
          elevation: 0, // 그림자 제거
          title: Text(
            '같이TA', // 화면 제목
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A55A2),
            ),
          ),
          actions: [
            // 마일리지 충전 액션
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => _navigateToMileageRechargeScreen(context), // 충전 화면으로 이동
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on_rounded,
                        color: Color(0xFF4A55A2),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${mileageProvider.currentMileage}', // 현재 마일리지 표시
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 앱 로고 이미지
                      Image.asset(
                        'assets/symbol.png',
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(height: 40),
                      // 마일리지가 충분한 경우
                      if (mileageProvider.currentMileage >= 3500) ...[
                        Text(
                          '방을 찾아보세요!',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '함께 이동할 친구를 찾아보세요',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 32),
                        // 방 찾기 버튼
                        ElevatedButton(
                          onPressed: () => _navigateToRoomListScreen(context), // 방 탐색 화면으로 이동
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A55A2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '방 찾기',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                      // 마일리지가 부족한 경우
                      if (mileageProvider.currentMileage < 3500) ...[
                        Text(
                          '마일리지가 부족합니다',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '매칭을 시작하려면 최소 3,500 마일리지가 필요해요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // 푸터 메시지
                Text(
                  'made by Software',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'WAGURI',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 마일리지 충전 화면으로 이동
  void _navigateToMileageRechargeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MileageRechargeScreen(),
      ),
    );
  }

  /// 방 탐색 화면으로 이동 (경로 안내 팝업 포함)
  void _navigateToRoomListScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 경로 안내 팝업 구성
              Text(
                '경로 안내',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoomListScreen()),
                  ); // 방 탐색 화면으로 이동
                },
                child: Text('확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

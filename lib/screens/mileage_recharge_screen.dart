import 'package:flutter/material.dart';
import 'payment_screen.dart';

/// MileageRechargeScreen 클래스
/// - 마일리지 충전 금액을 선택할 수 있는 화면 제공
/// - 선택한 금액에 따라 결제 화면(PaymentScreen)으로 이동
class MileageRechargeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 화면 배경색 설정
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색
        elevation: 0, // AppBar 그림자 제거
        title: Text(
          '마일리지 충전', // 화면 제목
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Pretendard', // 커스텀 폰트 사용
            fontWeight: FontWeight.w700, // 굵은 글꼴
            color: Colors.black87, // 텍스트 색상
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87), // 뒤로가기 버튼 아이콘
          onPressed: () => Navigator.pop(context), // 이전 화면으로 이동
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24), // 화면 여백 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 좌측 정렬
          children: [
            // 충전 안내 텍스트
            Text(
              '충전할 금액을 선택해주세요',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 24), // 간격 추가
            // 마일리지 옵션 UI
            _buildMileageOption(context, '3500', '3,500원'),
            SizedBox(height: 12),
            _buildMileageOption(context, '5000', '5,000원'),
            SizedBox(height: 12),
            _buildMileageOption(context, '10000', '10,000원'),
          ],
        ),
      ),
    );
  }

  /// 마일리지 옵션 위젯 생성
  /// - [amount]: 충전할 마일리지 값
  /// - [displayAmount]: 사용자에게 표시될 금액 문자열
  Widget _buildMileageOption(
      BuildContext context, String amount, String displayAmount) {
    return InkWell(
      onTap: () {
        // PaymentScreen으로 이동하며 선택된 금액 전달
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(selectedAmount: amount),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20), // 컨테이너 내부 여백 설정
        decoration: BoxDecoration(
          color: Colors.grey[50], // 배경색 설정
          borderRadius: BorderRadius.circular(16), // 둥근 모서리
          border: Border.all(color: Colors.grey[200]!), // 테두리 설정
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
          children: [
            // 금액과 설명 텍스트
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 좌측 정렬
              children: [
                Text(
                  '$amount 마일리지', // 마일리지 값 표시
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600, // 굵은 글꼴
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  displayAmount, // 금액 표시
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            // 오른쪽 화살표 아이콘
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF4A55A2), // 아이콘 색상
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/mileage_provider.dart';

/// PaymentScreen 클래스
/// - 사용자가 마일리지 충전을 위해 결제를 진행할 수 있는 화면 제공
/// - 결제 정보 입력(카드번호, 유효기간, CVC) 및 결제 로직 구현
class PaymentScreen extends StatefulWidget {
  final String selectedAmount; // 사용자 선택 충전 금액

  /// 생성자
  /// - [selectedAmount]: 충전할 금액
  const PaymentScreen({Key? key, required this.selectedAmount})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String cardNumber; // 카드 번호
  late String expirationDate; // 유효기간
  late String cvc; // CVC 번호
  bool isProcessing = false; // 결제 처리 중 상태 플래그

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 설정
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색
        elevation: 0, // 그림자 제거
        title: Text(
          '결제하기', // AppBar 제목
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87), // 뒤로가기 버튼
          onPressed: () => Navigator.pop(context), // 이전 화면으로 이동
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24), // 화면 여백 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 확장
            children: [
              // 충전 금액 정보 컨테이너
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50], // 배경색
                  borderRadius: BorderRadius.circular(16), // 둥근 모서리
                  border: Border.all(color: Colors.grey[200]!), // 테두리 색상
                ),
                child: Row(
                  children: [
                    // 금액 아이콘
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF4A55A2).withOpacity(0.1), // 배경색
                        shape: BoxShape.circle, // 원형
                      ),
                      child: Icon(
                        Icons.monetization_on_rounded, // 아이콘
                        color: Color(0xFF4A55A2),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16), // 간격
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                      children: [
                        Text(
                          '충전 금액',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '${widget.selectedAmount} 마일리지', // 선택한 충전 금액
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(
                '카드 정보 입력', // 입력 안내 텍스트
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              // 카드 번호 입력 필드
              TextFormField(
                decoration: InputDecoration(
                  hintText: '카드 번호',
                  prefixIcon: Icon(Icons.credit_card, color: Color(0xFF4A55A2)),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number, // 숫자 입력 타입
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 허용
                onChanged: (value) => cardNumber = value, // 입력값 변경 시 상태 업데이트
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  // 유효기간 입력 필드
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '유효기간 (MM/YY)',
                        prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF4A55A2)),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.datetime, // 날짜 입력 타입
                      onChanged: (value) => expirationDate = value, // 상태 업데이트
                    ),
                  ),
                  SizedBox(width: 12),
                  // CVC 입력 필드
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'CVC',
                        prefixIcon: Icon(Icons.security, color: Color(0xFF4A55A2)),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number, // 숫자 입력 타입
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 허용
                      onChanged: (value) => cvc = value, // 상태 업데이트
                    ),
                  ),
                ],
              ),
              Spacer(), // 화면 아래로 버튼 배치
              // 결제하기 버튼
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isProcessing ? null : _processPayment, // 결제 로직 실행
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A55A2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isProcessing
                      ? CircularProgressIndicator(color: Colors.white) // 로딩 상태 표시
                      : Text(
                          '결제하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 결제 처리 로직
  Future<void> _processPayment() async {
    setState(() {
      isProcessing = true; // 결제 중 상태 설정
    });

    // 실제 결제 로직 (예제에서는 지연 후 성공 처리)
    await Future.delayed(Duration(seconds: 2));

    // 결제 성공 후 마일리지 충전
    final mileageProvider = Provider.of<MileageProvider>(context, listen: false);
    await mileageProvider.rechargeMileage(int.parse(widget.selectedAmount));

    setState(() {
      isProcessing = false; // 결제 완료 상태로 변경
    });

    Navigator.of(context).pop(true); // 성공 결과 반환
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/mileage_provider.dart';
import '../models/room_model.dart';
import 'room_list_screen.dart';
import 'room_screen.dart';
import 'payment_instruction_screen.dart';
import 'new_main_screen.dart';

/// SettlementConfirmationScreen 클래스
/// - 방 정산 화면
/// - 방장은 참가자의 송금 상태를 확인하고 정산을 완료할 수 있음.
/// - 참가자는 송금을 진행하고 송금 상태를 업데이트할 수 있음.
class SettlementConfirmationScreen extends StatelessWidget {
  final String roomId; // 방 ID
  final bool isCreator; // 방장 여부

  SettlementConfirmationScreen({
    required this.roomId,
    required this.isCreator,
  });

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context); // 방 데이터 관리
    final authProvider = Provider.of<AuthProvider>(context); // 사용자 인증 관리
    final mileageProvider = Provider.of<MileageProvider>(context); // 마일리지 관리
    bool hasShownSnackBar = false; // 스낵바 중복 표시 방지 플래그

    return WillPopScope(
      // 뒤로가기 버튼 동작 허용
      onWillPop: () async => true,
      child: StreamBuilder<RoomModel?>(
        stream: roomProvider.getRoomStream(roomId), // 실시간 방 데이터 스트림
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            // 데이터 로딩 중
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final room = snapshot.data!;
          final currentUserId = authProvider.user?.uid; // 현재 사용자 ID

          if (currentUserId == null) {
            return Scaffold(
              body: Center(child: Text('사용자 정보를 불러올 수 없습니다.')),
            );
          }

          // 참가자가 송금을 완료했을 때 스낵바 표시
          if (!isCreator &&
              room.payments[currentUserId] == true &&
              !hasShownSnackBar) {
            hasShownSnackBar = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '송금이 완료되었습니다',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Color(0xFF4A55A2),
                  duration: Duration(seconds: 2),
                ),
              );
            });
          }

          // 방장이 정산을 종료한 경우 방 목록 화면으로 이동
          if (!room.isSettling && isCreator) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => RoomListScreen()),
                (route) => false,
              );
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                isCreator ? '정산 관리' : '송금하기',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCreator ? '참가자 송금 현황' : '송금 정보',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: room.users.length, // 참가자 수
                      itemBuilder: (context, index) {
                        final userId = room.users[index]; // 참가자 ID
                        final isPaid = room.payments?[userId] ?? false; // 송금 상태
                        final isRoomCreator = userId == room.creatorUid; // 방장 여부

                        return FutureBuilder<String?>(
                          future: authProvider.getUserEmail(userId), // 이메일 가져오기
                          builder: (context, emailSnapshot) {
                            final userEmail = emailSnapshot.data ?? 'Loading...';

                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  // 송금 상태 아이콘
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: (isPaid || isRoomCreator)
                                          ? Color(0xFF4A55A2).withOpacity(0.1)
                                          : Colors.red[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      (isPaid || isRoomCreator)
                                          ? Icons.check_circle_outline
                                          : Icons.timer,
                                      size: 20,
                                      color: (isPaid || isRoomCreator)
                                          ? Color(0xFF4A55A2)
                                          : Colors.red[400],
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  // 사용자 정보
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userEmail, // 사용자 이메일
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          isRoomCreator
                                              ? '방장'
                                              : (isPaid ? '송금 완료' : '송금 대기'),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // 송금하기 버튼 (참가자 전용)
                  if (!isCreator && !(room.payments?[authProvider.user?.uid] ?? false)) ...[
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _sendPayment(context, room, mileageProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A55A2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '돈 보내기',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  // 정산 완료 버튼 (방장 전용)
                  if (isCreator) ...[
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _completeSettlement(context, roomId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A55A2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '정산 완료',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 참가자의 송금 처리 로직
  Future<void> _sendPayment(BuildContext context, RoomModel room, MileageProvider mileageProvider) async {
    try {
      final roomProvider = Provider.of<RoomProvider>(context, listen: false);
      final userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;

      int totalAmount = 4800; // 총 금액 (예: 4800원)
      int amountPerPerson = totalAmount ~/ room.users.length; // 1인당 금액

      await mileageProvider.deductMileage(amountPerPerson); // 마일리지 차감
      await roomProvider.updatePaymentStatus(room.id, userId, true); // 송금 상태 업데이트
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('송금 처리 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  /// 방장의 정산 완료 처리 로직
  Future<void> _completeSettlement(BuildContext context, String roomId) async {
    try {
      final roomProvider = Provider.of<RoomProvider>(context, listen: false);

      await roomProvider.completeSettlement(roomId); // 정산 완료 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('정산이 완료되었습니다.'),
          backgroundColor: Colors.green[400],
        ),
      );

      await Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RoomListScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('정산 완료 처리 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }
}

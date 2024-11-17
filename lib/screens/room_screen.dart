import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../providers/auth_provider.dart';
import '../models/room_model.dart';
import 'settlement_confirmation_screen.dart';
import 'payment_instruction_screen.dart';
import 'room_list_screen.dart';

/// RoomScreen 클래스
/// - 특정 방의 상세 정보를 표시하고 사용자의 방 참여, 방 나가기, 정산 등의 작업을 처리
/// - 방장과 일반 사용자 간의 권한과 기능을 구분하여 제공
class RoomScreen extends StatelessWidget {
  final String roomId; // 방의 고유 ID

  /// RoomScreen 생성자
  /// - [roomId]: 방의 고유 ID를 전달받아 화면에서 사용
  const RoomScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false); // 방 데이터 관리
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // 사용자 인증 관리
    final currentUserId = authProvider.user?.uid; // 현재 로그인된 사용자 ID

    return WillPopScope(
      // 뒤로가기 버튼 누를 때 실행할 동작 정의
      onWillPop: () async {
        if (currentUserId != null) {
          final isCreator = (await roomProvider.getRoom(roomId))?.creatorUid == currentUserId;
          await roomProvider.leaveRoom(roomId, currentUserId, isCreator); // 방 나가기 로직 처리
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 제거
          backgroundColor: Colors.white, // AppBar 배경색 설정
          elevation: 0, // 그림자 제거
          title: Text(
            '방', // 화면 제목
            style: TextStyle(
              fontFamily: 'WAGURI',
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () async {
              // 뒤로가기 버튼 누를 때 방 나가기 처리
              if (currentUserId != null) {
                final isCreator = (await roomProvider.getRoom(roomId))?.creatorUid == currentUserId;
                await roomProvider.leaveRoom(roomId, currentUserId, isCreator);

                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RoomListScreen()), // 방 목록 화면으로 이동
                  (route) => false,
                );
              }
            },
          ),
        ),
        body: StreamBuilder<RoomModel?>(
          stream: roomProvider.getRoomStream(roomId), // 실시간 방 데이터 스트림
          builder: (context, snapshot) {
            // 데이터 로딩 중일 때
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // 데이터 로드 중 오류 발생
            if (snapshot.hasError) {
              return Center(child: Text('오류가 발생했습니다.'));
            }

            // 방 데이터가 없는 경우
            if (!snapshot.hasData || snapshot.data == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final wasSettlementCompleted = await roomProvider.wasSettlementCompleted(roomId);

                if (!context.mounted) return;
                if (currentUserId != snapshot.data?.creatorUid) {
                  // 방장이 나갔을 경우 경고 팝업 표시
                  showDialog(
                    context: context,
                    barrierDismissible: false, // 팝업 외부 터치로 닫기 방지
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          wasSettlementCompleted ? '정산 완료' : '알림',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          wasSettlementCompleted
                              ? '정산이 완료되었습니다.'
                              : '방장이 방을 나갔습니다.',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => RoomListScreen()),
                                (route) => false,
                              );
                            },
                            child: Text(
                              '확인',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A55A2),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => RoomListScreen()),
                    (route) => false,
                  );
                }
              });
              return Center(child: CircularProgressIndicator());
            }

            final room = snapshot.data!; // 방 데이터
            bool isCreator = room.creatorUid == currentUserId; // 현재 사용자가 방장인지 확인
            final users = room.users; // 방 참가자 목록

            // 정산 중일 때 일반 사용자 정산 화면으로 이동
            if (room.isSettling && !isCreator) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettlementConfirmationScreen(
                      roomId: room.id,
                      isCreator: false,
                    ),
                  ),
                );
              });
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length, // 방 참가자 수
                    itemBuilder: (context, index) {
                      final userId = users[index]; // 참가자 ID
                      final isUserCreator = userId == room.creatorUid; // 방장 여부
                      final isCurrentUser = userId == currentUserId; // 현재 사용자 여부

                      return FutureBuilder<String?>(
                        future: authProvider.getUserEmail(userId), // 참가자 이메일 가져오기
                        builder: (context, emailSnapshot) {
                          if (emailSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final userEmail = emailSnapshot.data ?? 'Unknown'; // 이메일 정보

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50], // 배경색 설정
                                borderRadius: BorderRadius.circular(16), // 둥근 모서리
                                border: Border.all(color: Colors.grey[200]!), // 테두리 색상
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4A55A2).withOpacity(0.1), // 배경색
                                      shape: BoxShape.circle, // 원형 배경
                                    ),
                                    child: Icon(
                                      Icons.person, // 사용자 아이콘
                                      color: Color(0xFF4A55A2),
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                                      children: [
                                        Row(
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
                                            SizedBox(width: 8),
                                            if (isCurrentUser) ...[
                                              // 현재 사용자인 경우 '나' 표시
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200], // 배경색
                                                  borderRadius: BorderRadius.circular(12), // 둥근 모서리
                                                ),
                                                child: Text(
                                                  '나',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        if (isUserCreator) ...[
                                          // 방장 표시
                                          SizedBox(height: 4),
                                          Text(
                                            '방장',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF4A55A2),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // 방장용 기능 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      if (isCreator) ...[
                        ElevatedButton(
                          onPressed: () => _settleCosts(context, room), // 정산 시작
                          child: Text('정산하기'),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            await roomProvider.leaveRoom(roomId, currentUserId!, true); // 방 나가기
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => RoomListScreen()),
                              (route) => false,
                            );
                          },
                          child: Text('방 나가기'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 정산 시작
  void _settleCosts(BuildContext context, RoomModel room) async {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false); // 방 데이터 관리

    try {
      await roomProvider.startSettlement(room.id); // 정산 시작
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettlementConfirmationScreen(
            roomId: room.id,
            isCreator: true,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('정산을 시작할 수 없습니다.'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }
}

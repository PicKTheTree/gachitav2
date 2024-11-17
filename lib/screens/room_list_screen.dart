import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../providers/auth_provider.dart';
import '../models/room_model.dart';
import 'room_screen.dart';
import 'settlement_confirmation_screen.dart';
import 'new_main_screen.dart';

class RoomListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserId = authProvider.user?.uid;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => NewMainScreen()),
          (route) => false,
        );aimport 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../providers/auth_provider.dart';
import '../models/room_model.dart';
import 'room_screen.dart';
import 'settlement_confirmation_screen.dart';
import 'new_main_screen.dart';

/// RoomListScreen 클래스
/// - 사용자가 참여할 수 있는 방 목록을 표시하고, 방 생성 및 참가 기능 제공
/// - 방 정보와 참가자의 상태를 실시간으로 업데이트하여 사용자에게 표시
class RoomListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context); // 방 관련 데이터 관리
    final authProvider = Provider.of<AuthProvider>(context); // 사용자 인증 데이터 관리
    final currentUserId = authProvider.user?.uid; // 현재 사용자 ID

    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 시 메인 화면으로 이동
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => NewMainScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white, // 화면 배경색 설정
        appBar: AppBar(
          backgroundColor: Colors.white, // AppBar 배경색
          elevation: 0, // 그림자 제거
          title: Text(
            '방 목록', // 화면 제목
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87), // 뒤로가기 버튼
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => NewMainScreen()),
                (route) => false,
              );
            },
          ),
        ),
        body: StreamBuilder<List<RoomModel>>(
          stream: roomProvider.getRoomsStream(), // 실시간 방 목록 데이터 스트림
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터 로딩 중
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4A55A2),
                ),
              );
            } else if (snapshot.hasError) {
              // 오류 발생 시
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      '오류가 발생했습니다',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // 방 목록이 비어있을 경우
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.meeting_room_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      '아직 생성된 방이 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }

            // 방 목록 데이터 처리
            List<RoomModel> rooms = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ListView.separated(
                itemCount: rooms.length, // 방 개수
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  RoomModel room = rooms[index];
                  bool isCreator = room.creatorUid == currentUserId; // 현재 사용자가 방장인지 확인
                  bool isCurrentUserInRoom = room.users.contains(currentUserId); // 방에 참가 중인지 확인

                  return FutureBuilder<String?>(
                    future: authProvider.getUserEmail(room.creatorUid), // 방장 이메일 가져오기
                    builder: (context, creatorSnapshot) {
                      String creatorEmail = creatorSnapshot.data ?? 'Loading...';

                      return InkWell(
                        onTap: () => _joinRoom(context, room, currentUserId!), // 방 참가 기능
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              // 방 아이콘
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4A55A2).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.groups_rounded,
                                  color: Color(0xFF4A55A2),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              // 방 정보
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 방 제목 및 상태
                                    Row(
                                      children: [
                                        Text(
                                          room.title, // 방 제목
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (isCurrentUserInRoom) ...[
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                    SizedBox(height: 4),
                                    // 방장 정보
                                    Row(
                                      children: [
                                        Text(
                                          '방장: $creatorEmail',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        if (isCreator) ...[
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF4A55A2)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '방장',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF4A55A2),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    // 참가자 수 정보
                                    Text(
                                      '참가자: ${room.users.length}/4',
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
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Color(0xFF4A55A2),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createRoom(context), // 방 생성 기능
          backgroundColor: Color(0xFF4A55A2),
          elevation: 0,
          child: Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  /// 방 생성 로직
  Future<void> _createRoom(BuildContext context) async {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.uid;

    if (currentUserId == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '로그인이 필요합니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[400],
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String? roomTitle = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';
        return AlertDialog(
          title: Text('방 만들기'),
          content: TextField(
            onChanged: (value) => inputText = value,
            decoration: InputDecoration(hintText: '방 제목 입력'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
            TextButton(
                onPressed: () => Navigator.pop(context, inputText),
                child: Text('확인')),
          ],
        );
      },
    );

    if (roomTitle == null) return;

    try {
      final roomId = await roomProvider.createRoom(currentUserId, roomTitle);
      if (!context.mounted) return;

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoomScreen(roomId: roomId),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('방 생성에 실패했습니다'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  /// 방 참가 로직
  void _joinRoom(BuildContext context, RoomModel room, String userId) async {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    if (room.users.length < 4 && !room.users.contains(userId)) {
      await roomProvider.joinRoom(room.id, userId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomScreen(roomId: room.id)),
      );
    } else if (room.users.contains(userId)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomScreen(roomId: room.id)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '방이 가득 찼습니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  /// 정산 확인 화면으로 이동
  void _showSettlementConfirmation(BuildContext context, RoomModel room) {
    if (room.users.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '정산을 시작하려면 최소 2명 이상의 참가자가 필요합니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettlementConfirmationScreen(
          roomId: room.id,
          isCreator: false,
        ),
      ),
    );
  }
}

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            '방 목록',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => NewMainScreen()),
                (route) => false,
              );
            },
          ),
        ),
        body: StreamBuilder<List<RoomModel>>(
          stream: roomProvider.getRoomsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4A55A2),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      '오류가 발생했습니다',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.meeting_room_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      '아직 생성된 방이 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }

            List<RoomModel> rooms = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ListView.separated(
                itemCount: rooms.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  RoomModel room = rooms[index];
                  bool isCreator = room.creatorUid == currentUserId;
                  bool isCurrentUserInRoom = room.users.contains(currentUserId);

                  return FutureBuilder<String?>(
                    future: authProvider.getUserEmail(room.creatorUid),
                    builder: (context, creatorSnapshot) {
                      String creatorEmail = creatorSnapshot.data ?? 'Loading...';

                      return InkWell(
                        onTap: () => _joinRoom(context, room, currentUserId!),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4A55A2).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.groups_rounded,
                                  color: Color(0xFF4A55A2),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          room.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (isCurrentUserInRoom) ...[
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '방장: $creatorEmail',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        if (isCreator) ...[
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF4A55A2)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '방장',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF4A55A2),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '참가자: ${room.users.length}/4',
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
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Color(0xFF4A55A2),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createRoom(context),
          backgroundColor: Color(0xFF4A55A2),
          elevation: 0,
          child: Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  Future<void> _createRoom(BuildContext context) async {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.uid;

    if (currentUserId == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '로그인이 필요합니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[400],
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String? roomTitle = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text(
            '방 만들기',
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: '방 제목을 입력하세요',
              hintStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                color: Colors.black38,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF4A55A2)),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15,
              color: Colors.black87,
            ),
            onChanged: (value) => inputText = value,
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '취소',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, inputText),
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

    if (roomTitle == null) return;

    try {
      final roomId = await roomProvider.createRoom(currentUserId, roomTitle);

      if (!context.mounted) return;

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoomScreen(roomId: roomId),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '방 생성에 실패했습니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[400],
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _joinRoom(BuildContext context, RoomModel room, String userId) async {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    if (room.users.length < 4 && !room.users.contains(userId)) {
      await roomProvider.joinRoom(room.id, userId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomScreen(roomId: room.id)),
      );
    } else if (room.users.contains(userId)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomScreen(roomId: room.id)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '방이 가득 찼습니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  void _showSettlementConfirmation(BuildContext context, RoomModel room) {
    if (room.users.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '정산을 시작하려면 최소 2명 이상의 참가자가 필요합니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettlementConfirmationScreen(
          roomId: room.id,
          isCreator: false,
        ),
      ),
    );
  }
}

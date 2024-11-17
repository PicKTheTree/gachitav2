import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mileage_provider.dart';
import '../providers/room_provider.dart';

/// PaymentInstructionScreen 클래스
/// - 특정 방(Room ID)에 대한 송금 안내 화면을 제공
/// - 마일리지와 방 관련 데이터를 사용하여 사용자에게 송금 정보를 표시
class PaymentInstructionScreen extends StatelessWidget {
  final String roomId; // 송금 안내를 위한 방 ID

  /// 생성자
  /// - [roomId]: 송금 안내에 필요한 방의 고유 ID
  PaymentInstructionScreen({required this.roomId});

  @override
  Widget build(BuildContext context) {
    final mileageProvider = Provider.of<MileageProvider>(context); // 마일리지 데이터 제공
    final roomProvider = Provider.of<RoomProvider>(context); // 방 데이터 제공

    return Scaffold(
      appBar: AppBar(
        title: Text('송금 안내'), // 화면 제목
      ),
      body: Center(
        child: Text(
          '송금 안내 화면입니다. Room ID: $roomId', // Room ID를 표시
        ),
      ),
    );
  }
}

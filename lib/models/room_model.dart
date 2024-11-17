/// 방 데이터를 관리하는 RoomModel 클래스
/// - 방의 ID, 제목, 방장 UID, 참가자 목록, 결제 상태, 활동 기록 및 정산 상태를 저장
/// - Firebase와 데이터 교환을 위해 `fromMap`과 `toMap` 메서드를 제공

class RoomModel {
  final String id; // 방 고유 ID
  final String title; // 방 제목
  final String creatorUid; // 방장 사용자 ID
  final List<String> users; // 방 참가자 목록
  final Map<String, bool> payments; // 참가자별 결제 상태
  final List<Map<String, dynamic>> history; // 방의 활동 기록 (예: 정산 내역)
  final bool isSettling; // 현재 정산 중인지 여부

  /// RoomModel 생성자
  /// - [id]: 방 고유 ID (필수)
  /// - [title]: 방 제목 (필수)
  /// - [creatorUid]: 방장 사용자 ID (필수)
  /// - [users]: 방 참가자 목록 (필수)
  /// - [payments]: 참가자별 결제 상태 (기본값: 빈 Map)
  /// - [history]: 방의 활동 기록 (기본값: 빈 리스트)
  /// - [isSettling]: 정산 상태 (기본값: false)

  RoomModel({
    required this.id,
    required this.title,
    required this.creatorUid,
    required this.users,
    Map<String, bool>? payments,
    List<Map<String, dynamic>>? history,
    this.isSettling = false,
  })  : this.payments = payments ?? {}, // 결제 상태가 null일 경우 빈 Map으로 초기화
        this.history = history ?? []; // 활동 기록이 null일 경우 빈 리스트로 초기화

  /// Firebase 데이터에서 RoomModel 객체 생성
  /// - [data]: Firebase에서 가져온 Map 데이터
  /// - [id]: Firebase에서 제공하는 방 고유 ID
  factory RoomModel.fromMap(Map<String, dynamic> data, String id) {
    return RoomModel(
      id: id, 
      title: data['title'] ?? '', 
      creatorUid: data['creatorUid'] ?? '', 
      users: List<String>.from(data['users'] ?? []), 
      payments: Map<String, bool>.from(data['payments'] ?? {}), 
      history: List<Map<String, dynamic>>.from(data['history'] ?? []), 
      isSettling: data['isSettling'] ?? false, 
    );
  }

  /// RoomModel 객체를 Firebase에 저장할 Map 데이터로 변환
  /// - 반환값: 방 정보를 포함한 Map
  Map<String, dynamic> toMap() {
    return {
      'title': title, // 방 제목
      'creatorUid': creatorUid, // 방장 사용자 ID
      'users': users, // 참가자 목록
      'payments': payments, // 결제 상태
      'history': history, // 활동 기록
      'isSettling': isSettling, // 정산 상태
    };
  }
}

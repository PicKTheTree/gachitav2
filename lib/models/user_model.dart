/// 사용자 데이터를 관리하는 UserModel 클래스
/// - 사용자의 ID, 이메일, 이름, 마일리지를 저장
/// - Firebase와의 데이터 교환을 위해 `fromMap`과 `toMap` 메서드를 제공
class UserModel {
  final String uid; // 사용자 고유 ID
  final String email; // 사용자 이메일
  final String name; // 사용자 이름
  int mileage; // 사용자 마일리지 (기본값: 0)

  /// UserModel 생성자
  /// - [uid]: 사용자 고유 ID (필수)
  /// - [email]: 사용자 이메일 (필수)
  /// - [name]: 사용자 이름 (필수)
  /// - [mileage]: 사용자 마일리지 (기본값: 0)
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.mileage = 0,
  });

  /// Firebase 데이터에서 UserModel 객체 생성
  /// - [data]: Firebase에서 가져온 Map 데이터
  /// - [uid]: Firebase에서 제공하는 사용자 고유 ID
  /// - 각 필드는 Firebase에 값이 없을 경우 기본값을 사용
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid, // 사용자 ID
      email: data['email'] ?? '', // 이메일 (기본값: 빈 문자열)
      name: data['name'] ?? '', // 이름 (기본값: 빈 문자열)
      mileage: data['mileage'] ?? 0, // 마일리지 (기본값: 0)
    );
  }

  /// UserModel 객체를 Firebase에 저장할 Map 데이터로 변환
  /// - 반환값: 이메일, 이름, 마일리지 정보만 포함한 Map
  Map<String, dynamic> toMap() {
    return {
      'email': email, // 사용자 이메일
      'name': name, // 사용자 이름
      'mileage': mileage, // 사용자 마일리지
    };
  }
}

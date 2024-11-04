# 같이TA - 택시 동승 정산 앱

## 📱 프로젝트 소개
같이TA는 대학교를 목적지로하는 택시 동승 시 발생하는 정산 과정을 간편하게 처리할 수 있는 모바일 애플리케이션입니다. 학생(사용자)들은 방을 만들어 함께 탑승한 사람들과 쉽게 정산할 수 있습니다.

## ✨ 주요 기능
- **방 생성 및 참여**
  - 방장이 정산 방을 생성
  - 다른 사용자들이 방에 참여
  - 실시간으로 참여자 목록 확인

- **마일리지 시스템**
  - 마일리지 충전
  - 정산 시 마일리지로 송금
  - 잔액 실시간 확인

- **정산 프로세스**
  - 방장이 정산 시작
  - 참여자들의 송금 현황 실시간 확인
  - 모든 참여자 송금 완료 시 정산 완료

## 🛠 기술 스택
- **Frontend**
  - Flutter
  - Provider (상태 관리)
  - Material Design

- **Backend**
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Realtime Database

## 📦 주요 패키지
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^x.x.x
  firebase_auth: ^x.x.x
  cloud_firestore: ^x.x.x
  provider: ^x.x.x
```

## 🏗 프로젝트 구조
```
lib/
├── main.dart
├── models/
│   ├── room_model.dart
│   └── user_model.dart
├── providers/
│   ├── auth_provider.dart
│   ├── room_provider.dart
│   ├── user_provider.dart
│   └── mileage_provider.dart
├── screens/
│   ├── login_screen.dart
│   ├── room_list_screen.dart
│   ├── room_screen.dart
│   ├── payment_screen.dart
│   ├── payment_instruction_screen.dart   
│   └── settlement_screen.dart
└── services/
    └── firebase_service.dart
```

## 🚀 설치 및 실행
1. Flutter 개발 환경 설정
```bash
flutter pub get
```

2. Firebase 프로젝트 설정
- `google-services.json` (Android) 및 `GoogleService-Info.plist` (iOS) 파일 추가
- Firebase 콘솔에서 필요한 서비스 활성화

3. 앱 실행
```bash
flutter run
```

## 📱 스크린샷
[스크린샷 이미지들 추가 예정]

## 🔒 보안 및 데이터 처리
- Firebase Authentication을 통한 사용자 인증
- 실시간 데이터 동기화
- 안전한 마일리지 거래 처리

## 🤝 기여하기
1. 이 저장소를 포크합니다
2. 새로운 브랜치를 생성합니다
3. 변경사항을 커밋합니다
4. 브랜치에 푸시합니다
5. Pull Request를 생성합니다



## 👥 팀 멤버
- [김민준] - 파이어베이스,provider,논문작성
- [김석민] - 마일리지,메인스크린,논문작성
- [박경태] - 메인스크린,논문작성 

## 📞 문의하기
프로젝트에 대한 문의사항이 있으시면 [owgodo@gmail.com] 로 연락해주세요.
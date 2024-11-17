// login_screen
// 요약 : auth_provider에서 정보를 받은 후 로그인을 완료하는 메서드가 포함되어 있다. 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/mileage_provider.dart';
import '../screens/new_main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // 폼 검증을 위한 GlobalKey
  bool _isLoading = false; // 로그인 진행 상태를 나타내는 플래그
  final _emailController = TextEditingController(); // 이메일 입력 필드의 컨트롤러
  final _passwordController = TextEditingController(); // 비밀번호 입력 필드의 컨트롤러

  // 로그인 요청 메서드
  Future<void> signIn(BuildContext context) async {
    // 이메일과 비밀번호가 입력되지 않은 경우 알림 메시지 표시
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '이메일과 비밀번호를 입력해주세요',
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

    setState(() {
      _isLoading = true; // 로딩 상태로 설정
    });

    try {
      // AuthProvider와 MileageProvider 인스턴스 가져오기
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final mileageProvider = Provider.of<MileageProvider>(context, listen: false);

      // 로그인 요청 수행
      await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        mileageProvider,
      );

      // 로그인 성공 시
      if (!context.mounted) return; // context가 유효하지 않은 경우 작업 중단

      // 사용자 정보가 존재하는지 확인
      if (authProvider.user != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => NewMainScreen()), // 사용자 정보가 있다면, 메인 화면으로 이동
          (route) => false, // 이전 화면 제거
        );
      } else {
        throw Exception('사용자 정보를 불러오는데 실패했습니다.'); // 사용자 정보가 없을 경우, 예외 발생
      }

    } catch (e) {
      if (!context.mounted) return;

      // 로그인 실패 시 에러 메시지 정의
      String errorMessage = '로그인에 실패했습니다.';
      if (e.toString().contains('user-not-found')) {
        errorMessage = '존재하지 않는 계정입니다.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = '비밀번호가 올바르지 않습니다.';
      }

      // 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[400],
          duration: Duration(seconds: 2), // 메시지 표시 시간
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // 로딩 상태 해제
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 화면 배경색 설정
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24), // 좌우 패딩
              child: Form(
                key: _formKey, // 폼 검증용 Key
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '로그인', 
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12), 
                    Text(
                      '서비스 이용을 위해 로그인해 주세요',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 32),
                    // 이메일 입력 필드
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: '이메일',
                        prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF4A55A2)),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Color(0xFF4A55A2), width: 1.5),
                        ),
                      ),
                      style: TextStyle(fontFamily: 'Pretendard', fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    // 비밀번호 입력 필드
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true, // 입력값이 보이지 않도록 설정
                      decoration: InputDecoration(
                        hintText: '비밀번호',
                        prefixIcon: Icon(Icons.lock_outlined, color: Color(0xFF4A55A2)),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Color(0xFF4A55A2), width: 1.5),
                        ),
                      ),
                      style: TextStyle(fontFamily: 'Pretendard', fontSize: 16),
                    ),
                    SizedBox(height: 32),
                    // 로그인 버튼
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Color(0xFF4A55A2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        minimumSize: Size(double.infinity, 60),
                      ),
                      onPressed: () => signIn(context), // 버튼 클릭 시 로그인 시도
                      child: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              '로그인',
                              style: TextStyle(fontSize: 18, fontFamily: 'Pretendard', fontWeight: FontWeight.w600),
                            ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 비밀번호 찾기 버튼
                        TextButton(
                          onPressed: () {
                            // 비밀번호 찾기 기능
                          },
                          child: Text(
                            '비밀번호 찾기',
                            style: TextStyle(color: Colors.black54, fontFamily: 'Pretendard', fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 1,
                          color: Colors.black26,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        // 회원가입 버튼
                        TextButton(
                          onPressed: () {
                            // 회원가입 페이지로 이동
                          },
                          child: Text(
                            '회원가입',
                            style: TextStyle(color: Color(0xFF4A55A2), fontFamily: 'Pretendard', fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
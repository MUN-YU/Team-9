import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grand_market/0_screens/_signup/EmailVerificationService.dart';
import 'package:grand_market/0_screens/_signup/SignUp.dart';
import 'package:grand_market/0_screens/_signup/verify.dart';
import 'package:http/http.dart' as http;
import '../1_login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final bool _isLoading = false;
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _confirmPwController = TextEditingController();
  String? _passwordError;
  String? _selectedMajor;
  final _emailController = TextEditingController();
  final _emailAuthController = TextEditingController();
  String? _emailAuthError;
  String? _emailError;
  bool _isValid = false;
  bool _isRegisterable = false;

  // void sendTestEmail() async {
  //   await sendEmail(
  //     toEmail: 'docong0120@g.skku.edu',
  //     subject: 'Test Email from Flutter',
  //     text: 'This is a test email sent using Mailgun.',
  //   );
  // }

  final List<String> _majors = [
    "화학공학/고분자시스템공학부",
    "신소재공학부",
    "기계공학부",
    "건설환경공학부",
    "시스템경영공학과",
    "나노공학과",
    "식품생명공학과",
    "바이오메카트로닉스학과",
    "융합생명공학과",
    "생명과학과",
    "수학과",
    "물리학과",
    "화학과",
    "경제학과",
    "통계학과",
    "행정학과",
    "정치외교학과",
    "미디어커뮤니케이션학과",
    "사회학과",
    "사회복지학과",
    "심리학과",
    "소비자학과",
    "아동·청소년학과",
    "유학·동양학과",
    "국어국문학과",
    "영어영문학과",
    "프랑스어문학과",
    "러시아어문학과",
    "중어중문학과",
    "독어독문학과",
    "한문학과",
    "사학과",
    "철학과",
    "문헌정보학과",
    "소프트웨어학과",
    "데이터사이언스융합전공",
    "인공지능융합전공",
    "컬처앤테크놀로지융합전공",
    "자기설계융합전공",
    "지능형소프트웨어학과",
    "약학과",
    "스포츠과학과",
    "의학과",
    "글로벌바이오메디컬공학과",
    "응용AI융합학부",
    "에너지학과"
  ];

  void _validatePasswordMatch() {
    setState(() {
      _passwordError = (_pwController.text == _confirmPwController.text)
          ? null
          : '비밀번호가 일치하지 않습니다.';
    });
  }

  void _validateEmail() {
    print("hey");
    bool isEmailValid = false;
    if (_emailController.text.endsWith('@g.skku.edu') ||
        _emailController.text.endsWith('@skku.edu')) isEmailValid = true;

    setState(() {
      _emailError = isEmailValid ? null : '이메일을 올바르게 입력해주세요.';
      _isValid = isEmailValid;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _pwController.dispose();
    _confirmPwController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    final name = _nameController.text;
    final id = _idController.text;
    final pw = _pwController.text;
    final email = _emailController.text;
    final major = _selectedMajor ?? '';

    final url = Uri.parse('https://swe9.comit-server.com/api/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": name,
          "id": id,
          "password": pw,
          "major": major,
          "email": email,
          "isValid": _isValid,
        }),
      );

      if (response.statusCode == 201) {
        // handleEmailVerification(email);
        print('회원가입 성공: ${response.body}');
        Fluttertoast.showToast(msg: "환영합니다!");
        _nameController.clear();
        _idController.clear();
        _pwController.clear();
        _confirmPwController.clear();
        _emailController.clear();
        // Navigate back to the LoginScreen after successful sign-up

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print('회원가입 실패: ${response.statusCode}, ${response.body}');
        Fluttertoast.showToast(msg: "회원가입 실패, 입력을 확인해주세요!");
      }
    } catch (error) {
      print('에러 발생: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 37, 26),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '회원 가입',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            /*-------------------------------------------*/
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFC4D5BA),
          padding: const EdgeInsets.all(16.0),
          child: SignUp(
            nameController: _nameController,
            idController: _idController,
            pwController: _pwController,
            confirmPwController: _confirmPwController,
            passwordError: _passwordError,
            onPasswordChange: _validatePasswordMatch,
            selectedMajor: _selectedMajor,
            majors: _majors,
            onMajorChanged: (String? newValue) {
              setState(() {
                _selectedMajor = newValue;
              });
            },
            emailController: _emailController,
            emailError: _emailError,
            onEmailChange: _validateEmail,
            isValid: _isValid,
            emailAuthController: _emailAuthController,
            emailAuthError: _emailAuthError,
            registerable: () {
              setState(() {
                _isRegisterable = true;
              });
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF204020),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Center(
            child: SizedBox(
              width: 450,
              height: 70,
              child: ElevatedButton(
                onPressed: _isRegisterable
                    ? () {
                        print(_isRegisterable);
                        print("yeah");
                        _submitData();
                      }
                    : () {
                        print(_isRegisterable);
                        Fluttertoast.showToast(msg: "가입 요건이 충족되지 않았습니다.");
                      },

                // onPressed: handleEmailVerification(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC4D5BA),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "회원가입하기",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

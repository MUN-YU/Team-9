import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grand_market/0_screens/_signup/EmailVerificationService.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController idController;
  final TextEditingController pwController;
  final TextEditingController confirmPwController;
  final String? passwordError;
  final VoidCallback onPasswordChange;
  final String? selectedMajor;
  final List<String> majors;
  final ValueChanged<String?> onMajorChanged;
  final TextEditingController emailController;
  final String? emailError;
  final VoidCallback onEmailChange;
  final bool isValid;
  final TextEditingController emailAuthController;
  final String? emailAuthError;
  final VoidCallback registerable;

  const SignUp({
    required this.nameController,
    required this.idController,
    required this.pwController,
    required this.confirmPwController,
    required this.passwordError,
    required this.onPasswordChange,
    required this.selectedMajor,
    required this.majors,
    required this.onMajorChanged,
    required this.emailController,
    required this.emailError,
    required this.onEmailChange,
    required this.isValid,
    required this.emailAuthController,
    required this.emailAuthError,
    required this.registerable,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isEmailSent = false;
  EmailVerificationService? verify;

  bool _validateEmail(String email) {
    bool isEmailValid = false;
    if (email.endsWith('@g.skku.edu') || email.endsWith('@skku.edu'))
      isEmailValid = true;
    return isEmailValid;
  }

  Future<void> sendEmail({
    required String toEmail,
    required String subject,
    required String text,
  }) async {
    final url = Uri.parse('https://api.mailgun.net/v3/$domain/messages');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('api:$apiKey'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'from': 'thegrandmarket@$domain',
        'to': toEmail,
        'subject': subject,
        'text': text,
      },
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
      Fluttertoast.showToast(msg: "이메일을 확인해주시기 바랍니다!");
    } else {
      print('Failed to send email: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void sendEmailforVerify(String userEmail) async {
    final verificationService = EmailVerificationService();

    if (userEmail == null) {
      Fluttertoast.showToast(msg: "아직 이메일이 입력되지 않았습니다.");
    } else if (_validateEmail(userEmail)) {
      // 인증 코드 생성
      final verificationCode = verificationService.generateVerificationCode();
      verify = verificationService;

      // 사용자에게 이메일 발송
      await sendEmail(
        toEmail: userEmail,
        subject: 'Your Verification Code',
        text: 'Your verification code is: $verificationCode',
      );

      Fluttertoast.showToast(msg: "Verification code sent to $userEmail");
      _isEmailSent = true;
    } else
      Fluttertoast.showToast(
          msg: "@g.skku.edu 또는 @skku.edu\n도메인 이메일을 이용해주시기 바랍니다.");
  }

  void verifyEmail() {
    if (_isEmailSent) {
      String userInputCode = widget.emailAuthController.text; // 사용자가 입력한 코드
      if (verify!.verifyCode(userInputCode)) {
        print('Email verified successfully!');
        Fluttertoast.showToast(msg: "성공적으로 인증되었습니다.");
        widget.registerable();
      } else {
        print('Invalid verification code.');
        Fluttertoast.showToast(msg: "인증에 실패하였습니다.");
      }
    } else {
      Fluttertoast.showToast(msg: "이메일이 입력되지 않았습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromARGB(255, 20, 37, 26);
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('이름', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        TextField(
          controller: widget.nameController,
          decoration: InputDecoration(
            hintText: '이름 입력',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 10),
        const Text('아이디', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        TextField(
          controller: widget.idController,
          decoration: InputDecoration(
            hintText: '아이디 입력',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 10),
        const Text('비밀번호', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        TextField(
          controller: widget.pwController,
          obscureText: true,
          onChanged: (_) => widget.onPasswordChange(),
          decoration: InputDecoration(
            hintText: '비밀번호 입력',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text('비밀번호 확인', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        TextField(
          controller: widget.confirmPwController,
          obscureText: true,
          onChanged: (_) => widget.onPasswordChange(),
          decoration: InputDecoration(
            hintText: '비밀번호 재입력',
            errorText: widget.passwordError,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 10),
        const Text('학과', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: widget.selectedMajor,
          hint: const Text('학과 선택'),
          items: widget.majors.map((String major) {
            return DropdownMenuItem<String>(
              value: major,
              child: Text(major),
            );
          }).toList(),
          onChanged: widget.onMajorChanged,
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('학교 이메일 입력', style: TextStyle(fontSize: 20)),
            SizedBox(
              width: width - 320,
            ),
            ElevatedButton(
              onPressed: () => sendEmailforVerify(widget.emailController.text),
              child: Text("인증번호 요청"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF204020),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.emailController,
          onChanged: (_) => widget.onEmailChange(),
          decoration: InputDecoration(
            hintText: '@g.skku.edu, @skku.edu',
            errorText: widget.emailError,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('이메일 인증번호 입력', style: TextStyle(fontSize: 20)),
            SizedBox(
              width: width - 360,
            ),
            ElevatedButton(
              onPressed: () => verifyEmail(),
              child: Text("인증번호 확인"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF204020),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.emailAuthController,
          onChanged: (_) => widget.onEmailChange(),
          decoration: InputDecoration(
            hintText: "6자리 숫자",
            errorText: widget.emailAuthError,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}

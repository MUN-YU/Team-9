import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../_signup/sign_up_screen.dart';
import '../5_main/main_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://swe9.comit-server.com/api/auth/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "id": _idController.text,
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final token = responseData["content"]["token"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token);

      setState(() {
        _isLoading = false;
      });

      // Navigate to MainScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      print("로그인 실패: ${response.body}");
    }
  }

  void _navigateToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 20, 37, 26),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 37, 26),
        title: const Text(
          "로그인",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100), // 부드러운 애니메이션 효과
              height: isKeyboardVisible ? 150 : 300, // 키보드 상태에 따른 이미지 높이
              width: isKeyboardVisible ? 150 : 300, // 키보드 상태에 따른 이미지 너비
              child: Image.asset("assets/images/logo/logo_white_moon.png"),
            ),
            const Spacer(flex: 1),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: "아이디",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "비밀번호",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 28),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        backgroundColor: Color.fromARGB(255, 222, 211, 27),
                      ),
                      onPressed: _login,
                      child: const Text(
                        "로그인",
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 37, 26),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _navigateToSignUp,
              child: const Text(
                "회원가입",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

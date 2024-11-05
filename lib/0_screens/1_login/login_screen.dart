import 'package:flutter/material.dart';
import '../5_main/main_screen.dart';

class LoginPage extends StatefulWidget {
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

    // 로그인 로직 (Firebase 등 추가 가능)
    await Future.delayed(const Duration(seconds: 2)); // 가짜 로그인 처리

    setState(() {
      _isLoading = false;
    });

    // 로그인 성공 후 메인 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Image.asset("assets/images/logo/logo_white_moon.png"),
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
                            color: const Color.fromARGB(255, 20, 37, 26)),
                      ),
                    ),
                  ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

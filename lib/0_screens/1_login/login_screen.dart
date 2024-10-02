import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // 로딩 상태

  /*
   * 로그인 함수
  */
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    // 여기에 실제 로그인 로직 추가 (Firebase 등)
    await Future.delayed(const Duration(seconds: 2)); // 가짜 로그인 로직 (2초 지연)

    setState(() {
      _isLoading = false;
    });

    // 로그인 후 처리 (현재는 단순한 성공 메시지)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Success"),
          content: const Text("You have successfully logged in."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
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
                labelText: "계정",
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
                ? const CircularProgressIndicator() // 로딩 중일 때 표시
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          backgroundColor: const Color.fromARGB(255, 222, 211, 27)),
                      onPressed: _login,
                      child: const Text(
                        "로그인",
                        style: TextStyle(
                            color: Color.fromARGB(255, 20, 37, 26)),
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

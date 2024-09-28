import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // 로딩 상태

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    // 여기에 실제 로그인 로직 추가 (Firebase 등)
    await Future.delayed(Duration(seconds: 2)); // 가짜 로그인 로직 (2초 지연)

    setState(() {
      _isLoading = false;
    });

    // 로그인 후 처리 (현재는 단순한 성공 메시지)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Login Success"),
          content: Text("You have successfully logged in."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
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
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 2),
            Image.asset("assets/images/logo/logo_white_moon.png"),
            Spacer(flex: 1),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: "ID",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 28),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
            ),
            SizedBox(height: 28),
            _isLoading
                ? CircularProgressIndicator() // 로딩 중일 때 표시
                : ElevatedButton(
                    onPressed: _login,
                    child: Text("Login"),
                  ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

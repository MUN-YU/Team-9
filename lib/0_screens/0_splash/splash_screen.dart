import 'package:flutter/material.dart';
import 'package:grand_market/0_screens/1_login/login_screen.dart';
import '../_mypage/my_page_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyPageScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grand_market/0_screens/1_login/login_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller; //애니메이션 컨트롤러
  late Animation<double> _animation; //애니메이션 정의

  @override
  void initState() {
    super.initState();

    //2초 동안 지속, vsync 디바이스 FPS에 맞춰서
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    //애니메이션, 100부터 0까지 값 변화량
    _animation = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(
        curve: Curves.bounceInOut,
        parent: _controller,
      ),
    );

    _controller.forward();
    _nextScreen();
  }

  Future<void> _nextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 37, 26),
      body: Column(children: [
        const SizedBox(
          height: 150,
        ),
        AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: child,
              );
            },
            child: Image.asset("assets/images/logo/logo_green_moon.png")),
      ]),
    );
  }
}

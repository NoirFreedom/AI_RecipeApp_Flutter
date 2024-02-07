import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fridgeat/features/authentication/login/login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late String _randomImage;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    // 네 개의 이미지 중 랜덤하게 하나의 이미지 선택
    List<String> images = [
      'assets/images/loadingimg1.jpg',
      'assets/images/loadingimg2.jpg',
    ];
    _randomImage =
        images[Random().nextInt(images.length)]; // 0부터 3까지의 정수 중 하나를 랜덤하게 선택

    // 3초 후에 로그인 화면으로 이동
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
      });
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const LoginScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = 0.0;
                var end = 1.0;
                var tween = Tween(begin: begin, end: end);
                var opacityAnimation = animation.drive(tween);

                return FadeTransition(
                  opacity: opacityAnimation,
                  child: child,
                );
              },
            ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(seconds: 1),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_randomImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

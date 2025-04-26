import 'dart:async';
import '../main/ask_page.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    // เริ่ม fade หลังจากแสดง splash 2.5 วิ
    Timer(const Duration(milliseconds: 2500), () async {
      await _animationController.forward();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AskPage()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Image.asset(
            'assets/images/cmmlogo.png',
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}

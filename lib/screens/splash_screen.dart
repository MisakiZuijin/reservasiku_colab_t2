import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
      body: Center(
        child: Image.asset('assets/images/Logo_White.png', height: 250, width: 250),
      ),
    );
  }
}
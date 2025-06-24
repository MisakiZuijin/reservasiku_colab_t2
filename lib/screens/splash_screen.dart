import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/app_route.dart';
import '../services/session_service.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final sessionService = SessionService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
    final uri = Uri.base;

    if (uri.path == '/reset-password' && uri.queryParameters['code'] != null) {
      final code = uri.queryParameters['code'];
      Get.offAllNamed('/reset-password', arguments: code);
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // ✅ Sudah login aktif
      Get.offAllNamed(AppRoutes.users);
      return;
    }

    final sessionService = SessionService();
    if (sessionService.isRemembered()) {
      final saved = sessionService.getSavedLogin();
      final auth = AuthService();
      final error = await auth.login(saved['email']!, saved['password']!);

      if (error == null) {
        final role = await auth.getUserRole();
        Get.offAllNamed(role == 'Admin' ? AppRoutes.admin : AppRoutes.users);
        return;
      }
    }

    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            "assets/images/Logo_White.png",
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}

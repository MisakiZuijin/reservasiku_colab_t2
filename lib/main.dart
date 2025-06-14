import 'package:flutter/material.dart';
import 'package:reservasiku_colab_t2/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '../../utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reservasiku Building',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen.shade600,
        ),
      ),
      // initialRoute: AppRoutes.splash,
      // getPages: AppRoutes.routes,
      home: SplashScreen(),
    );
  }
}

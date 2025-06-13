import 'package:flutter/material.dart';
import 'package:reservasiku_colab_t2/controllers/reservation_controller.dart';
import 'package:reservasiku_colab_t2/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:reservasiku_colab_t2/utils/app_routes.dart';
import 'package:reservasiku_colab_t2/controllers/nav_controller.dart'; // Tambahkan ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi controller
  Get.put(NavController());
  Get.put(ReservationController()); // Tambahkan ini

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
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      home: const SplashScreen(), // gunakan const jika memungkinkan
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reservasiku_colab_t2/controllers/reservation_controller.dart';
import 'package:reservasiku_colab_t2/controllers/nav_controller.dart';
import 'package:reservasiku_colab_t2/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'utils/app_route.dart';
import 'utils/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(NavController());
  Get.put(ReservationController());

  await SupabaseConfig.init();
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
      home: SplashScreen(),
    );
  }
}

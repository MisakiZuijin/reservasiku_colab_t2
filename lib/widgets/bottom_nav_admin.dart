import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reservasiku_colab_t2/screens/stats/StatsAdminScreen.dart';
import '../controllers/nav_controller.dart';
import '../screens/home/admin/dashboard_admin.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../utils/app_route.dart';

class BottomNavAdmin extends StatelessWidget {
  BottomNavAdmin({super.key});

  final navController = Get.find<NavController>();

  void _handleNavigation(int index) async {
    if (navController.selectedIndex.value != index) {
      navController.changeTabIndex(index);
      switch (index) {
        case 0:
          Get.offAll(() => const DashboardAdminScreen());
          break;
        case 1:
          navController.handleInvoice();
          Get.to(() => const StatsAdminScreen());
          break;
        case 2:
          // Logout dan kembali ke login
          await AuthService().logout();
          SessionService().clearLogin();
          navController.handleLogout();
          Get.offAllNamed(AppRoutes.login);
          break;
      }
    } else {
      navController.isLogoutActive(true);
      Get.offAll(() => const DashboardAdminScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isProfile = navController.isProfileActive.value;
      final currentIndex = navController.selectedIndex.value;
      const navColor = Color(
        0xFF5DFF00,
      ); // warna hijau stabil seperti versi lama

      return SafeArea(
        child: SizedBox(
          height: 80,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background nav bar
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: navColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color:
                            currentIndex == 0 ? Colors.white : Colors.white70,
                      ),
                      onPressed: () => _handleNavigation(0),
                    ),
                    const SizedBox(width: 50), // space for center button
                    IconButton(
                      icon: Icon(
                        Icons.logout, // Ganti icon person menjadi logout
                        color:
                            currentIndex == 2 ? Colors.white : Colors.white70,
                      ),
                      onPressed: () => _handleNavigation(2),
                    ),
                  ],
                ),
              ),

              // Center Laporan Penjualan Button
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                bottom: isProfile ? 25 : 25,
                child: GestureDetector(
                  onTap: () {
                    if (!isProfile) _handleNavigation(1);
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                    child:
                        isProfile
                            ? CircleAvatar(
                              key: const ValueKey("profile"),
                              radius: 30,
                              backgroundColor: const Color.fromARGB(
                                0,
                                255,
                                255,
                                255,
                              ),
                            )
                            : Container(
                              key: const ValueKey("report"),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: navColor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                              ),
                              child: const Icon(
                                Icons
                                    .bar_chart, // Ganti icon + menjadi bar_chart
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

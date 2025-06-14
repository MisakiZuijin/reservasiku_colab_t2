import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import '../screens/home/users/dashboard_users.dart';
import '../screens/profile/profile.dart';
import '../screens/reservation/reservation_form.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  final navController = Get.find<NavController>();

  void _handleNavigation(int index) {
    if (navController.selectedIndex.value != index) {
      navController.changeTabIndex(index);
      switch (index) {
        case 0:
          Get.offAll(() => const DashboardUsersScreen());
          break;
        case 1:
          Get.to(() => const ReservationForm());
          break;
        case 2:
          Get.offAll(() => const ProfileScreen());
          break;
      }
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
                        Icons.person,
                        color:
                            currentIndex == 2 ? Colors.white : Colors.white70,
                      ),
                      onPressed: () => _handleNavigation(2),
                    ),
                  ],
                ),
              ),

              // Center Add/Profile Button
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
                              key: const ValueKey("add"),
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
                                Icons.add,
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

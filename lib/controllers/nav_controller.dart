import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;
  var isProfileActive = false.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    isProfileActive.value = index == 2; // Jika tab ke-3 (profile) aktif
  }
}

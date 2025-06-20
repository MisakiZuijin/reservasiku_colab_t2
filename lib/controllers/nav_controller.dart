import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;
  var isProfileActive = false.obs;
  var isLogoutActive = false.obs;
  var isInvoiceActive = false.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    isProfileActive.value = index == 2; // Jika tab ke-3 (profile) aktif
  }

  void resetNav() {
    isLogoutActive.value = false; // reset status logout biar bersih
    selectedIndex.value = 0; // kembali ke dashboard (tab index 0)
    isProfileActive.value = false;
    isInvoiceActive.value = false;
  }

  /// Panggil ini ketika logout berhasil
  void handleLogout() {
    isLogoutActive.value = true;
    resetNav();
  }

  void handleInvoice() {
    isInvoiceActive.value = true;
    resetNav();
  }
}

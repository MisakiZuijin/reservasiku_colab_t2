import 'package:get/get.dart';
import 'package:reservasiku_colab_t2/screens/auth/reset_password.dart';
import '../../screens/splash_screen.dart';
import '../../screens/auth/login.dart';
import '../../screens/auth/register.dart';
import '../../screens/home/admin/dashboard_admin.dart';
import '../../screens/home/users/dashboard_users.dart';
import '../../screens/profile/profile.dart';
import '../../screens/auth/forgot_password.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String admin = '/admin';
  static const String users = '/user';
  static const String profile = '/profile';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(name: admin, page: () => const DashboardAdminScreen()),
    GetPage(name: users, page: () => const DashboardUsersScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen()),
  ];
}

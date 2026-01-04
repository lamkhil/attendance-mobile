import 'package:get/get.dart';

import '../modules/absen/bindings/absen_binding.dart';
import '../modules/absen/views/absen_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/lokakarya/bindings/lokakarya_binding.dart';
import '../modules/lokakarya/views/lokakarya_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
import '../widgets/layout/screen_layout.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeLayout(child: const HomeView()),
      binding: HomeBinding(),
      transitionDuration: Duration.zero,
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => HomeLayout(child: const ProfileView()),
      transitionDuration: Duration.zero,
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HomeLayout(child: const HistoryView()),
      transitionDuration: Duration.zero,
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ABSEN,
      page: () => const AbsenView(),
      binding: AbsenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.LOKAKARYA,
      page: () => const LokakaryaView(),
      binding: LokakaryaBinding(),
    ),
    GetPage(
      name: "${_Paths.LOKAKARYA}/:id",
      page: () => const LokakaryaView(),
      binding: LokakaryaBinding(),
    ),
  ];
}

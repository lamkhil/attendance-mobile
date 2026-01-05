import 'package:absensi/app/global/controllers/app_controller.dart';
import 'package:absensi/app/routes/app_pages.dart';
import 'package:absensi/app/data/services/authentication_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashscreenController extends GetxController {
  final logoHeight = 0.0.obs;
  final box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    _animateLogo();
    _checkAuth();
  }

  void _animateLogo() {
    Future.delayed(const Duration(milliseconds: 100), () {
      logoHeight.value = 100;
    });
  }

  Future<void> _checkAuth() async {
    await Future.delayed(Duration.zero);
    final token = box.read('token');

    if (token == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    final res = await Authenticationservices.me();

    Get.find<AppController>().user.value = res.data;

    if (res.success && res.data != null) {
      Get.offAllNamed(Routes.HOME);
    } else {
      box.remove('token');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}

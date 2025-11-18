import 'package:absensi/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashscreenController extends GetxController {
  final logoHeight = 0.0.obs;

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      Get.offAllNamed(Routes.LOGIN);
    });

    Future.delayed(Duration(milliseconds: 100)).then((_) {
      logoHeight.value = 100;
    });
    super.onInit();
  }
}

import 'package:absensi/app/global/controllers/app_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
  }
}

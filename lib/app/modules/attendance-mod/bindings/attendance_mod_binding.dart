import 'package:get/get.dart';

import '../controllers/attendance_mod_controller.dart';

class AttendanceModBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceModController>(
      () => AttendanceModController(),
    );
  }
}

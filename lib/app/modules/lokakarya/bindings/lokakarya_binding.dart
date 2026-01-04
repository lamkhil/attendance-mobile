import 'package:get/get.dart';

import '../controllers/lokakarya_controller.dart';

class LokakaryaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LokakaryaController>(
      () => LokakaryaController(),
    );
  }
}

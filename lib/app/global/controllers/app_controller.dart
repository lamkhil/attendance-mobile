import 'package:absensi/app/data/models/user.dart';
import 'package:absensi/app/data/services/authentication_services.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  Rx<User?> user = Rx<User?>(null);

  Future<void> checkAuth() async {
    final res = await Authenticationservices.me();
    if (res.success && res.data != null) {
      user.value = res.data;
    } else {
      Get.snackbar('Oops!', "Failed to fetch user data. Please login again.");
    }
  }

  @override
  void onInit() {
    checkAuth();
    super.onInit();
  }
}

import 'package:absensi/app/data/models/user.dart';
import 'package:absensi/app/data/services/authentication_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppController extends GetxController {
  Rx<User?> user = Rx<User?>(null);

  Future<void> checkAuth() async {
    if (GetStorage().read('token') != null) {
      final res = await Authenticationservices.me();
      if (res.success && res.data != null) {
        user.value = res.data;
      } else {
        Get.snackbar('Oops!', "Failed to fetch user data. Please login again.");
      }
    }
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void onInit() {
    checkAuth();
    super.onInit();
  }
}

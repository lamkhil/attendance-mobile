import 'dart:async';

import 'package:absensi/app/data/models/summary.dart';
import 'package:absensi/app/data/services/authentication_services.dart';
import 'package:absensi/app/global/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final appController = Get.find<AppController>();
  Rx<MonthlyAttendanceSummary?> summary = Rx(null);
  late Timer _timer;

  final currentTime = ''.obs;
  final currentDate = ''.obs;
  final greeting = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _updateDateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDateTime();
    });
    getSummary();
  }

  Future<void> getSummary() async {
    final result = await Authenticationservices.monthlySummary(
      month: DateTime.now().month,
      year: DateTime.now().year,
    );

    if (result.success) {
      summary.value = result.data;
    }
  }

  void _updateDateTime() {
    final now = DateTime.now();

    currentTime.value = DateFormat('HH:mm').format(now);
    currentDate.value = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);

    final hour = now.hour;
    if (hour < 11) {
      greeting.value = 'Selamat Pagi';
    } else if (hour < 15) {
      greeting.value = 'Selamat Siang';
    } else if (hour < 18) {
      greeting.value = 'Selamat Sore';
    } else {
      greeting.value = 'Selamat Malam';
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}

import 'package:absensi/app/data/services/authentication_services.dart';
import 'package:absensi/app/global/controllers/app_controller.dart';
import 'package:absensi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  var isLoading = false.obs;
  var obscurePassword = true.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Email dan password wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    final res = await Authenticationservices.login(
      emailController.text,
      passwordController.text,
    );

    isLoading.value = false;

    if (!res.success) {
      Get.snackbar('Gagal', res.message ?? '');
      return;
    }

    Get.find<AppController>().user.value = res.data;
    Get.offAllNamed(Routes.HOME);
    // _showOtpDialog();
  }

  /* ================= OTP DIALOG ================= */

  void _showOtpDialog() {
    otpController.clear();

    Get.dialog(
      AlertDialog(
        title: const Text('Verifikasi OTP'),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            hintText: 'Masukkan OTP',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(onPressed: verifyOtp, child: const Text('Verifikasi')),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /* ================= VERIFY OTP ================= */

  Future<void> verifyOtp() async {
    if (otpController.text.length < 4) {
      Get.snackbar('Gagal', 'OTP tidak valid');
      return;
    }

    isLoading.value = true;

    final res = await Authenticationservices.verifyOtp(
      emailController.text,
      otpController.text,
    );

    Get.find<AppController>().user.value = res.data;

    isLoading.value = false;

    if (!res.success) {
      Get.snackbar('Gagal', res.message ?? '');
      return;
    }

    Get.back(); // tutup dialog
    Get.offAllNamed(Routes.HOME);

    Get.snackbar('Berhasil', 'Login berhasil');
  }
}

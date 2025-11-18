import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var obscurePassword = true.obs;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Email dan password wajib diisi",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    // Simulasi proses login
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Cek dummy login
    if (emailController.text == "123" && passwordController.text == "123") {
      Get.offAllNamed('/home');
      Get.snackbar(
        "Berhasil",
        "Login sukses!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Login gagal",
        "Email atau password salah",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

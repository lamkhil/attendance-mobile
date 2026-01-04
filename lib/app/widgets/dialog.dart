import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static Future<T?> loading<T>([Future<T>? loadingFunction]) async {
    final loadingDialog = Get.dialog<T>(
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: const CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );
    if (loadingFunction != null) {
      loadingDialog;
      final value = await loadingFunction;
      Get.back();
      return value;
    }
    return loadingDialog;
  }

  static Future<T?> error<T>({required String message}) async {
    return Get.dialog<T>(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<T?> basic<T>({
    required String title,
    required String message,
  }) => Get.dialog<T>(
    AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(message)),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Oke"),
        ),
      ],
    ),
  );

  static Future<T?> withAction<T>({
    required String title,
    required String message,
    required Function() positive,
    required Function() negative,
    required String positiveText,
    required String negativeText,
  }) => Get.dialog<T>(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(onPressed: negative, child: Text(negativeText)),
        ElevatedButton(onPressed: positive, child: Text(positiveText)),
      ],
    ),
  );
}

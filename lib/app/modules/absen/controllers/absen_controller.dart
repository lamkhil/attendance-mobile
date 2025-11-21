import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AbsenController extends GetxController {
  CameraController? cameraController;
  RxBool isCameraReady = false.obs;
  RxString base64Photo = ''.obs;
  Rx<Position?> position = Rx<Position?>(null);
  RxString timeString = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
    _initLocation();
    _startClock();
  }

  // CLOCK
  void _startClock() {
    timeString.value = _now();
    ever(timeString, (_) {});
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      timeString.value = _now();
      return true;
    });
  }

  String _now() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  // LOCATION
  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      position.value = await Geolocator.getCurrentPosition();
    } catch (e) {
      Get.snackbar("Error", "Failed to get location");
    }
  }

  // CAMERA
  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final CameraDescription backCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );

    cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController!.initialize();
    isCameraReady.value = true;
  }

  Future<void> takePicture() async {
    if (!cameraController!.value.isInitialized) return;

    final file = await cameraController!.takePicture();
    final b = await File(file.path).readAsBytes();
    base64Photo.value = base64Encode(b);
  }

  // UPLOAD
  Future<void> uploadAttendance() async {}
}

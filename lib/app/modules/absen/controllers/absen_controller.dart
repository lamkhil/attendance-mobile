import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:absensi/app/data/services/attendance_services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AbsenController extends GetxController {
  CameraController? cameraController;
  RxBool isCameraReady = false.obs;
  RxString base64Photo = ''.obs;
  Rx<Position?> position = Rx<Position?>(null);
  RxString timeString = ''.obs;
  int cameraIndex = 0;
  final cameraViewKey = GlobalKey();
  Rx<Uint8List?> capturedImage = Rx<Uint8List?>(null);
  Rx<Uint8List?> capturedWidget = Rx<Uint8List?>(null);

  @override
  void onInit() {
    super.onInit();
    _initCamera();
    _initLocation();
    _startClock();
  }

  Future<void> captureWidget() async {
    RenderRepaintBoundary boundary =
        cameraViewKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    capturedWidget.value = pngBytes;
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
    final permissions = await [Permission.camera].request();
    permissions.forEach((permission, status) {
      if (!status.isGranted) {
        Get.snackbar("Error", "Camera permission is required");
        return;
      }
    });
    final cameras = await availableCameras();
    final CameraDescription backCamera = cameras.first;

    cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController!.initialize();
    isCameraReady.value = true;
  }

  Future<void> switchCamera() async {
    final cameras = await availableCameras();
    cameraIndex = (cameraIndex + 1) % cameras.length;
    final selectedCamera = cameras[cameraIndex];

    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await cameraController!.initialize();
    isCameraReady.value = true;
  }

  Future<void> takePicture() async {
    if (!cameraController!.value.isInitialized) return;

    final file = await cameraController!.takePicture();
    capturedImage.value = await file.readAsBytes();
    await Future.delayed(Duration(milliseconds: 500));

    await cameraController!.initialize();
    await captureWidget();
  }

  Future<void> saveAttendance() async {
    if (position.value == null || capturedWidget.value == null) {
      Get.snackbar('Error', 'Pastikan lokasi dan foto tersedia');
      return;
    }

    final res = await AttendanceServices.submitAttendance(
      lat: position.value!.latitude,
      lng: position.value!.longitude,
      photoBytes: capturedWidget.value!,
    );

    if (res.success) {
      Get.snackbar('Berhasil', 'Presensi berhasil');
    } else {
      Get.snackbar('Error', res.message ?? 'Gagal presensi');
    }
  }
}

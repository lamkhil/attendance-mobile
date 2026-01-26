import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:absensi/app/data/services/attendance_services.dart';
import 'package:absensi/app/routes/app_pages.dart';
import 'package:absensi/app/widgets/dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class AttendanceModController extends GetxController {
  // CAMERA
  CameraController? cameraController;
  RxBool isCameraReady = false.obs;
  int cameraIndex = 0;
  final cameraViewKey = GlobalKey();

  // IMAGE
  Rx<Uint8List?> capturedImage = Rx<Uint8List?>(null);
  Rx<Uint8List?> capturedWidget = Rx<Uint8List?>(null);

  // LOCATION
  Rx<Position?> position = Rx<Position?>(null);
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  // DATE & TIME
  Rx<DateTime> selectedDateTime = DateTime.now().obs;
  RxString timeString = ''.obs;

  // STATE
  RxBool dialogShown = false.obs;

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();
    _initLocation();
    _startClock();
  }

  @override
  void onReady() {
    super.onReady();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!dialogShown.value) {
        _showConfigDialog();
        dialogShown.value = true;
      }
    });
  }

  // TEMP BUFFER (untuk dialog)
  DateTime? _tempDateTime;
  double? _tempLat;
  double? _tempLng;

  // CLOCK CONTROL
  bool _clockRunning = true;

  // ================= CLOCK =================

  void _startClock() {
    _updateTime();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_clockRunning) return true;

      _updateTime();
      return true;
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final base = selectedDateTime.value;

    final combined = DateTime(
      base.year,
      base.month,
      base.day,
      now.hour,
      now.minute,
      now.second,
    );

    selectedDateTime.value = combined;

    timeString.value =
        "${combined.year}-${combined.month.toString().padLeft(2, '0')}-${combined.day.toString().padLeft(2, '0')} "
        "${combined.hour.toString().padLeft(2, '0')}:"
        "${combined.minute.toString().padLeft(2, '0')}:"
        "${combined.second.toString().padLeft(2, '0')}";
  }

  // ================= LOCATION =================

  Future<void> _initLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      final pos = await Geolocator.getCurrentPosition();
      position.value = pos;
      latitude.value = pos.latitude;
      longitude.value = pos.longitude;
    } catch (_) {
      Get.snackbar("Error", "Gagal mendapatkan lokasi");
    }
  }

  // ================= CAMERA =================
  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // optional
    );

    if (image == null) return;

    capturedImage.value = await image.readAsBytes();
    await Future.delayed(const Duration(milliseconds: 400));
    await captureWidget();
  }

  Future<void> switchCamera() async {
    final cameras = await availableCameras();
    cameraIndex = (cameraIndex + 1) % cameras.length;

    cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.max,
      enableAudio: false,
    );

    await cameraController!.initialize();
    isCameraReady.value = true;
  }

  // ================= IMAGE =================

  Future<void> takePicture() async {
    if (!cameraController!.value.isInitialized) return;

    final file = await cameraController!.takePicture();
    capturedImage.value = await file.readAsBytes();

    await Future.delayed(const Duration(milliseconds: 400));
    await cameraController!.initialize();
    await captureWidget();
  }

  Future<void> captureWidget() async {
    final boundary =
        cameraViewKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    capturedWidget.value = byteData!.buffer.asUint8List();
  }

  // ================= SAVE =================

  Future<void> saveAttendance() async {
    if (capturedWidget.value == null) {
      Get.snackbar('Error', 'Foto belum tersedia');
      return;
    }

    AppDialog.loading();

    final compressedPhoto = await compressAndResize(
      capturedWidget.value!,
      quality: 70,
    );

    final res = await AttendanceServices.submitAttendance2(
      lat: latitude.value,
      lng: longitude.value,
      datetime: selectedDateTime.value.toIso8601String(),
      photoBytes: compressedPhoto,
    );

    Get.back();

    if (res.success) {
      Get.offAllNamed(Routes.HOME);
      Get.snackbar('Berhasil', 'Presensi berhasil');
    } else {
      Get.snackbar('Error', res.message ?? 'Presensi gagal');
    }
  }

  // ================= IMAGE COMPRESS =================

  Future<Uint8List> compressAndResize(
    Uint8List bytes, {
    int quality = 70,
    int maxWidth = 1024,
  }) async {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;

    final resized = img.copyResize(image, width: maxWidth);
    final compressed = img.encodeJpg(resized, quality: quality);

    return Uint8List.fromList(compressed);
  }

  // ================= POPUP CONFIG =================

  void _showConfigDialog() {
    // === COPY GLOBAL KE TEMP ===
    _tempDateTime = selectedDateTime.value;
    _tempLat = latitude.value;
    _tempLng = longitude.value;

    _clockRunning = false;

    final latController = TextEditingController(
      text: _tempLat?.toString() ?? '',
    );
    final lngController = TextEditingController(
      text: _tempLng?.toString() ?? '',
    );

    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          _clockRunning = true;
          return true;
        },
        child: AlertDialog(
          title: const Text('Konfigurasi Presensi'),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DATE
                ListTile(
                  title: const Text('Tanggal'),
                  subtitle: Text(
                    "${_tempDateTime!.year}-${_tempDateTime!.month.toString().padLeft(2, '0')}-${_tempDateTime!.day.toString().padLeft(2, '0')}",
                  ),
                  trailing: const Icon(Icons.date_range),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _tempDateTime!,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _tempDateTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          _tempDateTime!.hour,
                          _tempDateTime!.minute,
                          _tempDateTime!.second,
                        );
                      });
                    }
                  },
                ),

                // TIME
                ListTile(
                  title: const Text('Jam'),
                  subtitle: Text(
                    "${_tempDateTime!.hour.toString().padLeft(2, '0')}:${_tempDateTime!.minute.toString().padLeft(2, '0')}",
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_tempDateTime!),
                    );
                    if (picked != null) {
                      setState(() {
                        _tempDateTime = DateTime(
                          _tempDateTime!.year,
                          _tempDateTime!.month,
                          _tempDateTime!.day,
                          picked.hour,
                          picked.minute,
                        );
                      });
                    }
                  },
                ),

                const Divider(),

                TextField(
                  controller: latController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  onChanged: (v) => _tempLat = double.tryParse(v) ?? _tempLat,
                ),

                TextField(
                  controller: lngController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  onChanged: (v) => _tempLng = double.tryParse(v) ?? _tempLng,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clockRunning = true;
                Get.back();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // === COMMIT KE GLOBAL ===
                selectedDateTime.value = _tempDateTime!;
                latitude.value = _tempLat ?? latitude.value;
                longitude.value = _tempLng ?? longitude.value;

                _clockRunning = true;
                Get.back();
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    ).then((_) {
      latController.dispose();
      lngController.dispose();
    });
  }
}

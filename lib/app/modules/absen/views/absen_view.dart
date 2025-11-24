import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/absen_controller.dart';

class AbsenView extends GetView<AbsenController> {
  const AbsenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance")),
      body: Obx(() {
        if (!controller.isCameraReady.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.capturedWidget.value != null) {
          return Column(
            children: [
              Expanded(child: Image.memory(controller.capturedWidget.value!)),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      controller.capturedWidget.value = null;
                      controller.capturedImage.value = null;
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Ulangi",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      controller.saveAttendance();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Simpan",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          );
        }

        return Column(
          children: [
            // CAMERA PREVIEW
            Expanded(
              child: RepaintBoundary(
                key: controller.cameraViewKey,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Obx(
                        () => controller.capturedImage.value == null
                            ? CameraPreview(controller.cameraController!)
                            : Image.memory(
                                controller.capturedImage.value!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (controller.position.value != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16),
                            ),
                            color: Colors.grey.shade100.withAlpha(200),
                            boxShadow: [
                              BoxShadow(blurRadius: 4, color: Colors.black12),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lokasi:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                "Lat: ${controller.position.value!.latitude}, Lng: ${controller.position.value!.longitude}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Waktu:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  controller.timeString.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (controller.position.value != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(blurRadius: 4, color: Colors.black12),
                            ],
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                controller.position.value!.latitude,
                                controller.position.value!.longitude,
                              ),
                              initialZoom: 13,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 12,
                                    height: 12,
                                    point: LatLng(
                                      controller.position.value!.latitude,
                                      controller.position.value!.longitude,
                                    ),
                                    child: Icon(
                                      Icons.location_pin,
                                      size: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            if (controller.capturedImage.value == null)
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      await controller.takePicture();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Ambil Foto",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: IconButton(
                      onPressed: () async {
                        await controller.switchCamera();
                      },
                      icon: Icon(Icons.camera_rear),
                    ),
                  ),
                ],
              ),
            if (controller.capturedImage.value != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blue,
                ),
                onPressed: null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Mengambil Foto...",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
          ],
        );
      }),
    );
  }
}

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

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // CAMERA PREVIEW
              AspectRatio(
                aspectRatio: controller.cameraController!.value.aspectRatio,
                child: CameraPreview(controller.cameraController!),
              ),
              SizedBox(height: 16),

              // LOCATION + TIME INFO
              if (controller.position.value != null)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Colors.black12),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lokasi:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Lat: ${controller.position.value!.latitude}, Lng: ${controller.position.value!.longitude}",
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Waktu:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Obx(() => Text(controller.timeString.value)),
                    ],
                  ),
                ),

              SizedBox(height: 16),

              // MAP
              if (controller.position.value != null)
                SizedBox(
                  height: 200,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(
                        controller.position.value!.latitude,
                        controller.position.value!.longitude,
                      ),
                      initialZoom: 16,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40,
                            height: 40,
                            point: LatLng(
                              controller.position.value!.latitude,
                              controller.position.value!.longitude,
                            ),
                            child: Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  await controller.takePicture();
                  await controller.uploadAttendance();
                },
                child: Text("Ambil Foto & Upload"),
              ),
            ],
          ),
        );
      }),
    );
  }
}

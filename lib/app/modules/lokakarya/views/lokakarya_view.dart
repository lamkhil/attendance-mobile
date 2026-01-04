import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lokakarya_controller.dart';

class LokakaryaView extends GetView<LokakaryaController> {
  const LokakaryaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          // Jika izin lokasi ditolak
          if (controller.isLocationDenied.value) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_off, size: 80, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Lokasi ditolak. Tidak bisa melanjutkan.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.initLocation();
                  },
                  child: Text('Coba lagi'),
                ),
              ],
            );
          }

          // Jika izin belum diberikan dan sedang loading
          if (!controller.isLocationAllowed.value) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Meminta izin lokasi...', style: TextStyle(fontSize: 16)),
              ],
            );
          }

          // Jika lokasi sudah diijinkan
          final pos = controller.position.value;
          // Jika lokasi belum diambil
          if (pos == null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Sedang mengambil lokasi...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 80, color: Colors.blue),
              SizedBox(height: 16),
              Text('Lokasi berhasil diambil:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text(
                'Lat: ${pos.latitude}, Lon: ${pos.longitude}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          );
        }),
      ),
    );
  }
}

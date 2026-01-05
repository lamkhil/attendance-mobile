import 'package:absensi/app/global/controllers/app_controller.dart';
import 'package:absensi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[800],
        title: Text("Profil", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // FOTO & NAMA
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30),
            color: Colors.blue[800],
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 55, color: Colors.blue[800]),
                ),
                SizedBox(height: 12),
                Obx(
                  () => Text(
                    appController.user.value?.name ?? '...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Obx(
                  () => Text(
                    appController.user.value?.position ?? '...',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // INFO CARD
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() {
                final user = appController.user.value;
                if (user == null) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    _infoTile("Email", user.email, Icons.email),
                    _infoTile("Jabatan", user.position, Icons.badge),
                    _infoTile("Departemen", "DPMPTSP", Icons.apartment),
                    _infoTile("Nomor HP", user.phone ?? "-", Icons.phone),

                    SizedBox(height: 20),
                    // LOGOUT
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          GetStorage().erase();
                          appController.user.value = null;
                          Get.offAllNamed(Routes.LOGIN);
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // WIDGET TILE PROFIL
  // =========================
  Widget _infoTile(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

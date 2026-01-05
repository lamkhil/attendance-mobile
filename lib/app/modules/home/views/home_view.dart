import 'package:absensi/app/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.BLUE_ONE,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(
                      0.65,
                    ), // atur 0.2 - 0.7 sesuai gelap yang diinginkan
                    BlendMode.darken,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(radius: 30),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                "Selamat Pagi,\n${controller.appController.user.value?.name ?? '...'}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              );
                            }),
                            SizedBox(height: 8),
                            Text(
                              "Sudah presensi hari ini?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(height: 16),
                    Obx(
                      () => Text(
                        controller.currentTime.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                    Obx(
                      () => Text(
                        controller.currentDate.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            return Text(
                              controller.appController.user.value?.position ??
                                  '...',
                              style: TextStyle(
                                color: AppColors.BLUE_ONE,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                          SizedBox(height: 8),
                          Obx(
                            () => Text(
                              controller
                                      .appController
                                      .user
                                      .value
                                      ?.currentShift
                                      ?.label ??
                                  '-',
                              style: TextStyle(
                                color: AppColors.BLACK_ONE,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          const Divider(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Masuk",
                                      style: TextStyle(
                                        color: AppColors.BLACK_ONE,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Obx(
                                      () => Text(
                                        controller
                                                .appController
                                                .user
                                                .value
                                                ?.today
                                                ?.checkIn ??
                                            '-',
                                        style: TextStyle(
                                          color: AppColors.TEAL_ZERO,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: AppColors.GREY_THREE,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Pulang",
                                      style: TextStyle(
                                        color: AppColors.BLACK_ONE,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Obx(
                                      () => Text(
                                        controller
                                                .appController
                                                .user
                                                .value
                                                ?.today
                                                ?.checkOut ??
                                            '-',
                                        style: TextStyle(
                                          color: AppColors.PINK_ONE,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Ringkasan Kehadiran Bulan Ini",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.BLACK_ONE,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              child: Obx(
                () => GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.8, // sesuaikan proporsi
                  children: [
                    _infoCard(
                      "Tepat Waktu",
                      "${controller.summary.value?.onTime ?? '...'}",
                      Colors.blue,
                    ),
                    _infoCard(
                      "Terlambat",
                      "${controller.summary.value?.late ?? '...'}",
                      Colors.orange,
                    ),
                    _infoCard(
                      "Pulang Cepat",
                      "${controller.summary.value?.earlyLeave ?? '...'}",
                      Colors.red,
                    ),
                    _infoCard(
                      "Total Kehadiran",
                      "${controller.summary.value?.total ?? '...'}",
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

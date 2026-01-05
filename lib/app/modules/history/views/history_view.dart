import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Text(
              "History Kehadiran",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ================= LIST HISTORY =================
          Expanded(
            child: controller.obx(
              (attendances) => RefreshIndicator(
                onRefresh: () async =>
                    controller.fetchAttendanceHistory(reset: true),
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: attendances!.length + 1,
                  itemBuilder: (context, index) {
                    if (index < attendances.length) {
                      final a = attendances[index];
                      return _historyCard(
                        date: a.dateFormatted,
                        masuk: a.checkInFormatted,
                        pulang: a.checkOutFormatted,
                        status: a.statusText,
                      );
                    } else {
                      return controller.canLoadMore
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink();
                    }
                  },
                ),
              ),
              onLoading: _buildShimmer(),
              onEmpty: RefreshIndicator(
                onRefresh: () async =>
                    controller.fetchAttendanceHistory(reset: true),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 100),
                    const Center(child: Text("Belum ada riwayat")),
                    const SizedBox(height: 100),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.fetchAttendanceHistory(reset: true);
                        },
                        child: const Text("Muat Ulang"),
                      ),
                    ),
                  ],
                ),
              ),
              onError: (error) => RefreshIndicator(
                onRefresh: () async =>
                    controller.fetchAttendanceHistory(reset: true),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 100),
                    Center(child: Text(error ?? 'Terjadi kesalahan')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================== CARD RIWAYAT =====================================
  Widget _historyCard({
    required String date,
    required String masuk,
    required String pulang,
    required String status,
  }) {
    Color color;
    IconData icon;

    switch (status) {
      case "Hadir":
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case "Terlambat":
        color = Colors.orange;
        icon = Icons.access_time_filled;
        break;
      case "Tidak Masuk":
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case "Cuti":
        color = Colors.blue;
        icon = Icons.beach_access;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _timeBox("Masuk", masuk),
                    const SizedBox(width: 10),
                    _timeBox("Pulang", pulang),
                  ],
                ),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ===================================== BOX JAM MASUK/PULANG =====================================
  Widget _timeBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ===================================== SHIMMER LOADING =====================================
  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            height: 70,
          ),
        );
      },
    );
  }
}

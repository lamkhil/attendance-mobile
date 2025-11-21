import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "History Kehadiran",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _monthDropdown(),
              ],
            ),
          ),

          // ================= LIST HISTORY =================
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _historyCard(
                  date: "Senin, 10 Jan 2025",
                  masuk: "07:31",
                  pulang: "16:28",
                  status: "Terlambat",
                ),
                _historyCard(
                  date: "Selasa, 11 Jan 2025",
                  masuk: "07:25",
                  pulang: "16:30",
                  status: "Hadir",
                ),
                _historyCard(
                  date: "Rabu, 12 Jan 2025",
                  masuk: "-",
                  pulang: "-",
                  status: "Tidak Masuk",
                ),
                _historyCard(
                  date: "Kamis, 13 Jan 2025",
                  masuk: "-",
                  pulang: "-",
                  status: "Cuti",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // DROPDOWN FILTER BULAN
  // =====================================
  Widget _monthDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.blue[800],
          iconEnabledColor: Colors.white,
          value: "Januari 2025",
          onChanged: (v) {},
          items:
              [
                "Januari 2025",
                "Desember 2024",
                "November 2024",
                "Oktober 2024",
              ].map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
        ),
      ),
    );
  }

  // =====================================
  // CARD RIWAYAT
  // =====================================
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
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ICON STATUS
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(width: 14),

          // DETAIL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    _timeBox("Masuk", masuk),
                    SizedBox(width: 10),
                    _timeBox("Pulang", pulang),
                  ],
                ),
              ],
            ),
          ),

          // STATUS TEXT
          Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // =====================================
  // BOX KECIL UNTUK JAM MASUK/PULANG
  // =====================================
  Widget _timeBox(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.black54)),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

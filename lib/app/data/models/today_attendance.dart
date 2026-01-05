class TodayAttendance {
  final String date;
  final String day;
  final String? checkIn;
  final String? checkOut;
  final String status;
  final int workMinutes;

  TodayAttendance({
    required this.date,
    required this.day,
    this.checkIn,
    this.checkOut,
    required this.status,
    required this.workMinutes,
  });

  factory TodayAttendance.fromJson(Map<String, dynamic> json) {
    return TodayAttendance(
      date: json['date'],
      day: json['day'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      status: json['status'],
      workMinutes: json['work_minutes'] ?? 0,
    );
  }
}

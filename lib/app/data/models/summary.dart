class MonthlyAttendanceSummary {
  final int onTime;
  final int late;
  final int earlyLeave;
  final int total;

  MonthlyAttendanceSummary({
    required this.onTime,
    required this.late,
    required this.earlyLeave,
    required this.total,
  });

  factory MonthlyAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return MonthlyAttendanceSummary(
      onTime: json['on_time'] ?? 0,
      late: json['late'] ?? 0,
      earlyLeave: json['early_leave'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

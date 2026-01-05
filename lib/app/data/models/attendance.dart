import 'package:intl/intl.dart';
import 'attendance_log.dart';

class Attendance {
  final int id;
  final String slug;
  final int userId;
  final DateTime date;

  final DateTime? checkIn;
  final double? checkInLat;
  final double? checkInLng;
  final String? checkInPhoto;

  final DateTime? checkOut;
  final double? checkOutLat;
  final double? checkOutLng;
  final String? checkOutPhoto;

  final String status; // hadir, telat, izin, cuti
  final int workHours;
  final int overtimeHours;

  final List<AttendanceLog>? logs;

  Attendance({
    required this.id,
    required this.slug,
    required this.userId,
    required this.date,
    this.checkIn,
    this.checkInLat,
    this.checkInLng,
    this.checkInPhoto,
    this.checkOut,
    this.checkOutLat,
    this.checkOutLng,
    this.checkOutPhoto,
    required this.status,
    required this.workHours,
    required this.overtimeHours,
    this.logs,
  });

  // ==================== JSON ====================
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      slug: json['slug'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      checkIn: json['check_in'] != null
          ? DateTime.parse(json['check_in'])
          : null,
      checkInLat: (json['check_in_lat'] as num?)?.toDouble(),
      checkInLng: (json['check_in_lng'] as num?)?.toDouble(),
      checkInPhoto: json['check_in_photo'],
      checkOut: json['check_out'] != null
          ? DateTime.parse(json['check_out'])
          : null,
      checkOutLat: (json['check_out_lat'] as num?)?.toDouble(),
      checkOutLng: (json['check_out_lng'] as num?)?.toDouble(),
      checkOutPhoto: json['check_out_photo'],
      status: json['status'] ?? 'hadir',
      workHours: json['work_hours'] ?? 0,
      overtimeHours: json['overtime_hours'] ?? 0,
      logs: json['logs'] != null
          ? (json['logs'] as List)
                .map((e) => AttendanceLog.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'user_id': userId,
    'date': date.toIso8601String(),
    'check_in': checkIn?.toIso8601String(),
    'check_in_lat': checkInLat,
    'check_in_lng': checkInLng,
    'check_in_photo': checkInPhoto,
    'check_out': checkOut?.toIso8601String(),
    'check_out_lat': checkOutLat,
    'check_out_lng': checkOutLng,
    'check_out_photo': checkOutPhoto,
    'status': status,
    'work_hours': workHours,
    'overtime_hours': overtimeHours,
    'logs': logs?.map((e) => e.toJson()).toList(),
  };

  // ==================== GETTERS ====================
  String get dateFormatted {
    try {
      return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(date);
    } catch (_) {
      return date.toIso8601String();
    }
  }

  String get checkInFormatted {
    if (checkIn == null) return '-';
    return DateFormat('HH:mm').format(checkIn!);
  }

  String get checkOutFormatted {
    if (checkOut == null) return '-';
    return DateFormat('HH:mm').format(checkOut!);
  }

  String get statusText {
    switch (status.toLowerCase()) {
      case 'hadir':
        return 'Hadir';
      case 'telat':
        return 'Terlambat';
      case 'izin':
        return 'Izin';
      case 'cuti':
        return 'Cuti';
      default:
        return status;
    }
  }
}

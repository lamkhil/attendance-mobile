class AttendanceLog {
  final int id;
  final int attendanceId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? checkInLat;
  final double? checkInLng;
  final double? checkOutLat;
  final double? checkOutLng;
  final String? checkInPhoto;
  final String? checkOutPhoto;
  final DateTime createdAt;

  AttendanceLog({
    required this.id,
    required this.attendanceId,
    this.checkIn,
    this.checkOut,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    this.checkInPhoto,
    this.checkOutPhoto,
    required this.createdAt,
  });

  factory AttendanceLog.fromJson(Map<String, dynamic> json) {
    return AttendanceLog(
      id: json['id'],
      attendanceId: json['attendance_id'],
      checkIn: json['check_in'] != null
          ? DateTime.parse(json['check_in'])
          : null,
      checkOut: json['check_out'] != null
          ? DateTime.parse(json['check_out'])
          : null,
      checkInLat: json['check_in_lat'] != null
          ? (json['check_in_lat'] as num).toDouble()
          : null,
      checkInLng: json['check_in_lng'] != null
          ? (json['check_in_lng'] as num).toDouble()
          : null,
      checkOutLat: json['check_out_lat'] != null
          ? (json['check_out_lat'] as num).toDouble()
          : null,
      checkOutLng: json['check_out_lng'] != null
          ? (json['check_out_lng'] as num).toDouble()
          : null,
      checkInPhoto: json['check_in_photo'],
      checkOutPhoto: json['check_out_photo'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'attendance_id': attendanceId,
    'check_in': checkIn?.toIso8601String(),
    'check_out': checkOut?.toIso8601String(),
    'check_in_lat': checkInLat,
    'check_in_lng': checkInLng,
    'check_out_lat': checkOutLat,
    'check_out_lng': checkOutLng,
    'check_in_photo': checkInPhoto,
    'check_out_photo': checkOutPhoto,
    'created_at': createdAt.toIso8601String(),
  };
}

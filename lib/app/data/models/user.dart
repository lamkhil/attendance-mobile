import 'today_attendance.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String position;

  final String? profilePhoto;
  final String? phone;
  final String? nik;
  final DateTime? dateOfBirth;

  final TodayAttendance? today;
  final CurrentShift? currentShift;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.position,
    this.profilePhoto,
    this.phone,
    this.nik,
    this.dateOfBirth,
    this.today,
    this.currentShift,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'user',
      position: json['position'] ?? 'Staff',

      profilePhoto: json['profile_photo'],
      phone: json['phone'],
      nik: json['nik'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,

      today: json['today'] != null
          ? TodayAttendance.fromJson(json['today'])
          : null,

      currentShift: json['current_shift'] != null
          ? CurrentShift.fromJson(json['current_shift'])
          : null,
    );
  }
}

class CurrentShift {
  final String start;
  final String end;
  final String type;

  CurrentShift({required this.start, required this.end, required this.type});

  factory CurrentShift.fromJson(Map<String, dynamic> json) {
    return CurrentShift(
      start: json['start'],
      end: json['end'],
      type: json['type'],
    );
  }

  String get label => '$start - $end';
}

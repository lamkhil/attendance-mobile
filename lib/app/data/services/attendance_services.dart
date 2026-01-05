import 'package:absensi/app/data/models/attendance.dart';
import 'package:absensi/app/data/models/response_api.dart';
import 'package:absensi/app/network/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class AttendanceServices {
  /// Ambil daftar attendance user beserta lognya (dengan pagination)
  static Future<ResponseApi<List<Attendance>>> getAttendances({
    int page = 1,
  }) async {
    try {
      final res = await dio.get('/attendance', queryParameters: {'page': page});

      return ResponseApi<List<Attendance>>.fromJson(
        res.data,
        list: (res.data['data'] as List)
            .map((e) => Attendance.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      return ResponseApi<List<Attendance>>.error(
        e.response?.data?['message'] ?? 'Gagal mengambil data attendance',
      );
    } catch (e) {
      print(e.toString());
      return ResponseApi<List<Attendance>>.error('Terjadi kesalahan sistem');
    }
  }

  /// Ambil attendance hari ini
  static Future<ResponseApi<Attendance?>> getTodayAttendance() async {
    try {
      final res = await dio.get('/attendances/today');

      return ResponseApi<Attendance?>.fromJson(
        res.data,
        data: (json) => json != null ? Attendance.fromJson(json) : null,
      );
    } on DioException catch (e) {
      return ResponseApi<Attendance?>.error(
        e.response?.data?['message'] ?? 'Gagal mengambil data hari ini',
      );
    } catch (_) {
      return ResponseApi<Attendance?>.error('Terjadi kesalahan sistem');
    }
  }

  /// Submit attendance log
  static Future<ResponseApi<void>> submitAttendance({
    required double lat,
    required double lng,
    required Uint8List photoBytes,
  }) async {
    try {
      // 1️⃣ Upload photo ke /upload
      final uploadRes = await dio.post(
        '/upload',
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(photoBytes, filename: 'absen.png'),
        }),
      );

      final photoUrl = uploadRes.data['url'] as String;

      // 2️⃣ Kirim log ke /attendance/action
      final res = await dio.post(
        '/attendance/action',
        data: {'lat': lat, 'lng': lng, 'photo': photoUrl},
      );

      return ResponseApi<void>(
        message: res.data['success'] == true
            ? 'Presensi berhasil'
            : 'Gagal presensi',
        success: res.data['success'] == true,
      );
    } on DioException catch (e) {
      return ResponseApi<void>.error(
        e.response?.data['message'] ?? 'Gagal mengirim presensi',
      );
    } catch (_) {
      return ResponseApi<void>.error('Terjadi kesalahan sistem');
    }
  }
}

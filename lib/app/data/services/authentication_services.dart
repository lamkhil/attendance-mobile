import 'package:absensi/app/data/models/response_api.dart';
import 'package:absensi/app/data/models/user.dart';
import 'package:absensi/app/network/config.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class Authenticationservices {
  /* ================= LOGIN ================= */

  static Future<ResponseApi<void>> login(String email, String password) async {
    try {
      final res = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      return ResponseApi<void>(
        message: res.data['message'] ?? 'OTP telah dikirim',
      );
    } on DioException catch (e) {
      return ResponseApi<void>.error(
        e.response?.data?['message'] ?? 'Email atau password salah',
      );
    } catch (_) {
      return ResponseApi<void>.error('Terjadi kesalahan sistem');
    }
  }

  /* ================= VERIFY OTP ================= */

  static Future<ResponseApi<User>> verifyOtp(String email, String otp) async {
    try {
      final res = await dio.post(
        '/auth/login/verify-otp',
        data: {'email': email, 'otp': otp},
      );

      GetStorage().write('token', res.data['token']);

      return ResponseApi<User>.fromJson(
        res.data,
        (json) => User.fromJson(json),
      );
    } on DioException catch (e) {
      return ResponseApi<User>.error(
        e.response?.data?['message'] ?? 'OTP tidak valid',
      );
    } catch (_) {
      return ResponseApi<User>.error('Gagal verifikasi OTP');
    }
  }

  /* ================= FORGOT PASSWORD ================= */

  static Future<ResponseApi<void>> forgotPassword(String email) async {
    try {
      final res = await dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      return ResponseApi<void>(
        message: res.data['message'] ?? 'Link reset password telah dikirim',
      );
    } on DioException catch (e) {
      return ResponseApi<void>.error(
        e.response?.data?['message'] ?? 'Email tidak ditemukan',
      );
    } catch (_) {
      return ResponseApi<void>.error(
        'Gagal mengirim permintaan reset password',
      );
    }
  }

  /* ================= RESET PASSWORD ================= */

  static Future<ResponseApi<void>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final res = await dio.post(
        '/auth/reset-password',
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return ResponseApi<void>(
        message: res.data['message'] ?? 'Password berhasil direset',
      );
    } on DioException catch (e) {
      return ResponseApi<void>.error(
        e.response?.data?['message'] ?? 'Token tidak valid atau kadaluarsa',
      );
    } catch (_) {
      return ResponseApi<void>.error('Gagal reset password');
    }
  }

  /* ================= GET ME ================= */

  static Future<ResponseApi<User>> me() async {
    try {
      final res = await dio.get('/auth/me');

      return ResponseApi<User>.fromJson(
        res.data,
        (json) => User.fromJson(json),
      );
    } on DioException catch (e) {
      return ResponseApi<User>.error(
        e.response?.data?['message'] ?? 'Unauthorized',
      );
    } catch (_) {
      return ResponseApi<User>.error('Gagal mengambil data user');
    }
  }
}

import 'dart:async';

import 'package:absensi/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? token = GetStorage().read('token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    return super.onError(err, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if ((response.data['message'] ?? '').toString().contains(
      'Unauthenticated',
    )) {
      GetStorage().remove('token');
      getx.Get.offAllNamed(Routes.LOGIN);
    }
    return super.onResponse(response, handler);
  }
}

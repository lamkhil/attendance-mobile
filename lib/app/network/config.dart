import 'package:dio/dio.dart';

import 'interceptor/LoggingInterceptors.dart';
import 'interceptor/NetworkInterceptor.dart';

final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://apibaruabsen.nganjukkab.go.id',
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    followRedirects: true,
    validateStatus: (status) {
      return status! < 500;
    }))
  ..interceptors.add(LoggingInterceptors())
  ..interceptors.add(NetworkInterceptor());

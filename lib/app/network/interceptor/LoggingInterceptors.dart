// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print(
        "--> ${options.method.toUpperCase()} ${"" + (options.baseUrl) + (options.path)}");
    print("Headers:");
    options.headers.forEach((k, v) => print('$k: $v'));
    print("queryParameters:");
    options.queryParameters.forEach((k, v) => print('$k: $v'));
    if (options.data != null) {
      if (options.data is FormData) {
        print("Body: ${(options.data as FormData).fields}");
      }

      print("Body: ${options.data}");
    }
    print("--> END ${options.method.toUpperCase()}");

    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioError dioError, ErrorInterceptorHandler handler) async {
    print(
        "<-- ${dioError.message} ${(dioError.response != null ? (dioError.response!.requestOptions.baseUrl + dioError.response!.requestOptions.path) : 'URL')}");
    print(
        "${dioError.response != null ? dioError.response!.data : 'Unknown Error'}");
    print("<-- End error");
    return super.onError(dioError, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    print("<-- ${(response.statusCode)}");
    print(
        "<-- ${(response.requestOptions.baseUrl + response.requestOptions.path)}");
    print("Headers:");
    response.headers.forEach((k, v) => print('$k: $v'));
    log("Response: ${response.data}");
    print("<-- END HTTP");
    return super.onResponse(response, handler);
  }
}

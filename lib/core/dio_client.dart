import 'package:dio/dio.dart';
import 'package:clean_commerce/core/constansts.dart';

class DioClient {
  late Dio _dio;
  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );
  }

  void addInterceptor(List<Interceptor> interceptors) {
    _dio.interceptors.addAll(interceptors);
  }
}

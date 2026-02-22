import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://taskmanager.uat-lplusltd.com',
          connectTimeout: const Duration(seconds: 30),
        ),
      ) {
    dio.interceptors.add(PrettyDioLogger());
  }
}

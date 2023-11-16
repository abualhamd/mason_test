import 'package:dartz/dartz.dart';

import '../error/exception.dart';

abstract class ApiConsumer {
  Future<Either<ServerException, dynamic>> get(
      {required String path,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});
  Future<Either<ServerException, dynamic>> post(
      {required String path,
      required Map<String, dynamic> body,
      String? contentType,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters});
  Future<Either<ServerException, dynamic>> put({
    required String path,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}

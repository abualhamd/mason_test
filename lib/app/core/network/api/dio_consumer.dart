import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../../../injection_container.dart';
import '../error/exception.dart';
import 'api_consumer.dart';
import 'package:dio/dio.dart';
import 'app_interceptors.dart';
import 'end_points.dart';
import 'status_codes.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options = BaseOptions(
      baseUrl: EndPoints.baseUrl,
      // headers: {'Content-Type': ''},
      followRedirects: false,
      validateStatus: (status) {
        return status! < StatusCodes.internalServerError;
      },
    );

    client.interceptors.add(sl<AppInterceptors>());
    if (kDebugMode) {
      client.interceptors.add(sl<LogInterceptor>());
    }
  }

  @override
  Future<Either<ServerException, dynamic>> get(
      {required String path,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await client.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      return Right(response.data);
    } on DioException catch (error) {
      return Left(_handleDioError(error));
    }
  }

  @override
  Future<Either<ServerException, dynamic>> post(
      {required String path,
      required Map<String, dynamic> body,
      bool formDataEnabled = false,
      String? contentType,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.post(path,
          options: Options(contentType: contentType, headers: headers),
          data: formDataEnabled ? FormData.fromMap(body) : body,
          queryParameters: queryParameters);
      return Right(response.data);
    } on DioException catch (error) {
      return Left(_handleDioError(error));
    }
  }

  @override
  Future<Either<ServerException, dynamic>> put({
    required String path,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await client.put(path,
          data: body,
          queryParameters: queryParameters,
          options: Options(headers: headers));
      return Right(response.data);
    } on DioException catch (error) {
      return Left(_handleDioError(error));
    }
  }

  ServerException _handleDioError(DioException error) {
    late ServerException exception;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = const FetchDataException();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCodes.unauthorized:
          case StatusCodes.forbidden:
            exception = const UnauthorizedException();
          case StatusCodes.notFound:
            exception = const NotFoundException();
          case StatusCodes.conflict:
            exception = const ConflictException();
          case StatusCodes.internalServerError:
            exception = const InternalServerErrorException();
        }
        break;
      case DioExceptionType.cancel:
      // break;
      case DioExceptionType.badCertificate:
      // TODO: Handle this case.
      // break;
      case DioExceptionType.connectionError:
      // TODO: Handle this case.
      // break;
      case DioExceptionType.unknown:
        exception = const NoInternetConnectionException();
    }

    return exception;
  }
}

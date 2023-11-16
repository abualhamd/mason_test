class ServerException implements Exception {
  final String? msg;

  const ServerException({this.msg});
}

class FetchDataException extends ServerException {
  const FetchDataException() : super(msg: "Error During Communication");
}

class BadRequestException extends ServerException {
  const BadRequestException() : super(msg: "Bad Request");
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException() : super(msg: "Unauthorized");
}

class NotFoundException extends ServerException {
  const NotFoundException() : super(msg: "Requested Info Not Found");
}

class ConflictException extends ServerException {
  const ConflictException() : super(msg: "Conflict Occurred");
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException() : super(msg: "Internal Server Error");
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException() : super(msg: "No Internet Connection");
}

class CacheException implements Exception {}

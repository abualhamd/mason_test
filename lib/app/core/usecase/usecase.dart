import 'package:equatable/equatable.dart';

abstract class BaseUsecase<RetType, Params> {
  RetType call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

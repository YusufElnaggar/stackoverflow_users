import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});
}

class OfflineFailure extends Failure {
  const OfflineFailure({super.message = 'No internet connection'});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server failure'});
  @override
  List<Object?> get props => [message];
}

class DataSourceFailure extends Failure {
  const DataSourceFailure({required super.message});
  @override
  List<Object?> get props => [message];
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure({super.message = 'No data found'});
  @override
  List<Object?> get props => [message];
}

class WrongDataFailure extends Failure {
  const WrongDataFailure({super.message = 'Wrong data'});
  @override
  List<Object?> get props => [message];
}

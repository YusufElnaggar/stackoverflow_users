import 'package:dartz/dartz.dart';
import '../../domain/models/failures.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class NetworkService {
  Future<Either<Failure, JsonMap>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}

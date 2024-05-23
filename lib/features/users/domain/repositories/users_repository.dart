import 'package:dartz/dartz.dart';
import 'package:stackoverflow_users/features/users/data/models/users_response_model.dart';

import '../../../../core/domain/models/failures.dart';

abstract class UsersRepository {
  Future<Either<Failure, UsersResponseModel>> getUsers({
    int? page,
    int? pageSize,
  });
}

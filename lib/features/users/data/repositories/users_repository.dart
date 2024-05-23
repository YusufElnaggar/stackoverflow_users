import 'package:dartz/dartz.dart';
import 'package:stackoverflow_users/features/users/data/models/users_response_model.dart';

import '../../../../core/domain/models/failures.dart';
import '../../domain/repositories/users_repository.dart';
import '../data_source/remote_users_data_source.dart';

class UsersRespositoryImpl implements UsersRepository {
  final RemoteUsersDataSource usersDataSource;

  UsersRespositoryImpl(this.usersDataSource);

  @override
  Future<Either<Failure, UsersResponseModel>> getUsers({
    int? page,
    int? pageSize,
  }) async {
    try {
      final result = await usersDataSource.getUsers(
        page: page,
        pageSize: pageSize,
      );
      return result;
    } on Exception {
      return Left(
        DataSourceFailure(
          message: 'An error occurred while trying to get users',
        ),
      );
    }
  }
}

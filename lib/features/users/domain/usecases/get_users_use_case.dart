import 'package:dartz/dartz.dart';
import 'package:stackoverflow_users/features/users/data/models/users_response_model.dart';

import '../../../../core/domain/models/failures.dart';
import '../repositories/users_repository.dart';

class GetUsersUseCase {
  final UsersRepository _usersRepository;

  GetUsersUseCase(this._usersRepository);

  Future<Either<Failure, UsersResponseModel>> call({
    int? page,
    int? pageSize,
  }) async {
    try {
      return await _usersRepository.getUsers(
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      return const Left(
        DataSourceFailure(
          message: 'An error occurred while trying to get users',
        ),
      );
    }
  }
}

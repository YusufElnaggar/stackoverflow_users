import 'package:dartz/dartz.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';

import '../../../../core/domain/models/failures.dart';
import '../repositories/reputations_repository.dart';

class GetReputationsUseCase {
  final ReputationsRepository _usersRepository;

  GetReputationsUseCase(this._usersRepository);

  Future<Either<Failure, ReputationsResponseModel>> call({
    required int userId,
    int? page,
    int? pageSize,
  }) async {
    try {
      return await _usersRepository.getReputations(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      return Left(
        DataSourceFailure(
          message: 'An error occurred while trying to get users',
        ),
      );
    }
  }
}

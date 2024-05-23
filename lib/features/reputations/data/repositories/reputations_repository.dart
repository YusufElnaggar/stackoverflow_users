import 'package:dartz/dartz.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';

import '../../../../core/domain/models/failures.dart';
import '../../domain/repositories/reputations_repository.dart';
import '../data_source/remote_reputations_data_source.dart';

class ReputationsRespositoryImpl implements ReputationsRepository {
  final RemoteReputationsDataSource usersDataSource;

  ReputationsRespositoryImpl(this.usersDataSource);

  @override
  Future<Either<Failure, ReputationsResponseModel>> getReputations({
    required int userId,
    int? page,
    int? pageSize,
  }) async {
    try {
      final result = await usersDataSource.getReputations(
        userId: userId,
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

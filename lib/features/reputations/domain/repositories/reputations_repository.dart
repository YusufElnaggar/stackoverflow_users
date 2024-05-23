import 'package:dartz/dartz.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';

import '../../../../core/domain/models/failures.dart';

abstract class ReputationsRepository {
  Future<Either<Failure, ReputationsResponseModel>> getReputations({
    required int userId,
    int? page,
    int? pageSize,
  });
}

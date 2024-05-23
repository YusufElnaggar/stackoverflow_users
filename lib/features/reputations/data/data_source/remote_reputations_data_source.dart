import 'package:dartz/dartz.dart';
import 'package:stackoverflow_users/core/utils/constants/apis_constants.dart';

import '../../../../core/data/remote/network_service.dart';
import '../../../../core/domain/models/failures.dart';
import '../models/reputations_response_model.dart';

abstract class RemoteReputationsDataSource {
  Future<Either<Failure, ReputationsResponseModel>> getReputations({
    required int userId,
    int? page,
    int? pageSize,
  });
}

class RemoteReputationsDataSourceImpl implements RemoteReputationsDataSource {
  final NetworkService networkService;

  RemoteReputationsDataSourceImpl(this.networkService);

  @override
  Future<Either<Failure, ReputationsResponseModel>> getReputations({
    required int userId,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await networkService.get(
        APIsConstants.getReputationsRequest(userId),
        queryParameters: {
          'page': (page ?? 1).toString(),
          'pageSize': (pageSize ?? 30).toString(),
          'site': 'stackoverflow',
        },
      );

      return response.fold(
        (failure) => Left(failure),
        (json) => Right(ReputationsResponseModel.fromJson(json)),
      );
    } on FormatException {
      return Left(WrongDataFailure());
    } catch (e) {
      return Left(DataSourceFailure(message: e.toString()));
    }
  }
}

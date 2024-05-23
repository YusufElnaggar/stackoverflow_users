import 'package:dartz/dartz.dart';
import 'package:stackoverflow_users/core/utils/constants/apis_constants.dart';

import '../../../../core/data/remote/network_service.dart';
import '../../../../core/domain/models/failures.dart';
import '../models/users_response_model.dart';

abstract class RemoteUsersDataSource {
  Future<Either<Failure, UsersResponseModel>> getUsers({
    int? page,
    int? pageSize,
  });
}

class RemoteUsersDataSourceImpl implements RemoteUsersDataSource {
  final NetworkService networkService;

  RemoteUsersDataSourceImpl(this.networkService);

  @override
  Future<Either<Failure, UsersResponseModel>> getUsers({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await networkService.get(
        APIsConstants.usersRequest,
        queryParameters: {
          'page': (page ?? 1).toString(),
          'pageSize': (pageSize ?? 30).toString(),
          'site': 'stackoverflow',
        },
      );

      return response.fold(
        (failure) => Left(failure),
        (json) => Right(UsersResponseModel.fromJson(json)),
      );
    } on FormatException {
      return Left(WrongDataFailure());
    } catch (e) {
      return Left(DataSourceFailure(message: e.toString()));
    }
  }
}

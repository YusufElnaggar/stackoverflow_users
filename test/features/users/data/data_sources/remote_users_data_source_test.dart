import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:stackoverflow_users/core/data/remote/network_service.dart';
import 'package:stackoverflow_users/core/domain/models/failures.dart';
import 'package:stackoverflow_users/core/utils/constants/apis_constants.dart';
import 'package:stackoverflow_users/features/users/data/data_source/remote_users_data_source.dart';
import 'package:stackoverflow_users/features/users/data/models/users_response_model.dart';

class NetworkServiceMock extends Mock implements NetworkService {}

void main() {
  late RemoteUsersDataSourceImpl remoteUsersDataSource;
  late NetworkServiceMock networkService;

  setUp(() {
    networkService = NetworkServiceMock();
    remoteUsersDataSource = RemoteUsersDataSourceImpl(networkService);
  });

  group('getUsers', () {
    const page = 1;
    const pageSize = 30;
    const site = 'stackoverflow';

    test('should return UsersResponseModel when the request is successful',
        () async {
      // Arrange
      final responseJson = {
        'items': [],
        'has_more': false,
        'quota_max': 10000,
        'quota_remaining': 9999,
      };
      final expectedResponse = UsersResponseModel.fromJson(responseJson);

      when(() => networkService.get(
            APIsConstants.usersRequest,
            queryParameters: {
              'page': page.toString(),
              'pageSize': pageSize.toString(),
              'site': site,
            },
          )).thenAnswer(
        (_) async => Future.value(Right(responseJson)),
      );

      // Act
      final result = await remoteUsersDataSource.getUsers(
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isRight(), true);
      expect(result, Right<Failure, UsersResponseModel>(expectedResponse));
      verify(() => networkService.get(
            APIsConstants.usersRequest,
            queryParameters: {
              'page': page.toString(),
              'pageSize': pageSize.toString(),
              'site': site,
            },
          ));
      verifyNoMoreInteractions(networkService);
    });

    test('should return a Left with Failure when the request fails', () async {
      // Arrange
      const failure = ServerFailure();
      when(() => networkService.get(
            APIsConstants.usersRequest,
            queryParameters: {
              'page': page.toString(),
              'pageSize': pageSize.toString(),
              'site': site,
            },
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await remoteUsersDataSource.getUsers(
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isLeft(), true);
      expect(result, const Left<Failure, UsersResponseModel>(failure));
      verify(() => networkService.get(
            APIsConstants.usersRequest,
            queryParameters: {
              'page': page.toString(),
              'pageSize': pageSize.toString(),
              'site': site,
            },
          ));
      verifyNoMoreInteractions(networkService);
    });

    test(
        'should return a Left with WrongDataFailure when the response is invalid',
        () async {
      // Arrange
      when(() => networkService.get(
            APIsConstants.usersRequest,
            queryParameters: {
              'page': page.toString(),
              'pageSize': pageSize.toString(),
              'site': site,
            },
          )).thenAnswer((_) async => const Left(WrongDataFailure()));

      // Act
      final result = await remoteUsersDataSource.getUsers(
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isLeft(), true);
      expect(
          result, const Left<Failure, UsersResponseModel>(WrongDataFailure()));
      verify(() => networkService.get(
            APIsConstants.usersRequest,
            queryParameters: {
              'page': page.toString(),
              'pageSize': pageSize.toString(),
              'site': site,
            },
          ));
      verifyNoMoreInteractions(networkService);
    });

    test('should return a Left with DataSourceFailure when an exception occurs',
        () async {
      // Arrange
      final exception = Exception('Test exception');
      when(() => networkService.get(
            APIsConstants.usersRequest,
            queryParameters: {
              'page': page.toString(),
              'pageSize': pageSize.toString(),
              'site': site,
            },
          )).thenThrow(exception);

      // Act
      final result = await remoteUsersDataSource.getUsers(
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isLeft(), true);
      expect(
          result,
          Left<Failure, UsersResponseModel>(
              DataSourceFailure(message: exception.toString())));
      verify(() => networkService.get(
            APIsConstants.usersRequest,
            queryParameters: {
              'page': page.toString(),
              'pageSize': pageSize.toString(),
              'site': site,
            },
          ));
      verifyNoMoreInteractions(networkService);
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackoverflow_users/core/domain/models/failures.dart';
import 'package:stackoverflow_users/features/users/data/data_source/remote_users_data_source.dart';
import 'package:stackoverflow_users/features/users/data/models/users_response_model.dart';
import 'package:stackoverflow_users/features/users/data/repositories/users_repository.dart';

class MockRemoteUsersDataSource extends Mock implements RemoteUsersDataSource {}

void main() {
  late UsersRespositoryImpl repository;
  late MockRemoteUsersDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRemoteUsersDataSource();
    repository = UsersRespositoryImpl(mockDataSource);

    registerFallbackValue(const Left<Failure, UsersResponseModel>(
        DataSourceFailure(message: 'errors')));
  });

  group('getUsers', () {
    const page = 1;
    const pageSize = 10;
    const usersResponse = UsersResponseModel(
      hasMore: true,
      items: [],
    );

    test('should return UsersResponseModel when data source succeeds',
        () async {
      // Arrange
      when(() => mockDataSource.getUsers(page: page, pageSize: pageSize))
          .thenAnswer((_) async => const Right(UsersResponseModel(
                hasMore: true,
                items: [],
              )));

      // Act
      final result = await repository.getUsers(page: page, pageSize: pageSize);

      // Assert
      expect(result.isRight(), true);
      expect(result, const Right<Failure, UsersResponseModel>(usersResponse));
      verify(() => mockDataSource.getUsers(page: page, pageSize: pageSize))
          .called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return DataSourceFailure when data source throws an exception',
        () async {
      // Arrange
      when(() => mockDataSource.getUsers(page: page, pageSize: pageSize))
          .thenThrow(Exception());

      // Act
      final result = await repository.getUsers(page: page, pageSize: pageSize);

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockDataSource.getUsers(page: page, pageSize: pageSize))
          .called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackoverflow_users/core/domain/models/failures.dart';
import 'package:stackoverflow_users/features/users/data/models/users_response_model.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/users_repository.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/get_users_use_case.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  late GetUsersUseCase useCase;
  late MockUsersRepository mockRepository;

  setUp(() {
    mockRepository = MockUsersRepository();
    useCase = GetUsersUseCase(mockRepository);
  });

  group('call', () {
    const page = 1;
    const pageSize = 10;
    const usersResponse = UsersResponseModel(
      hasMore: true,
      items: [],
    );

    test('should return UsersResponseModel when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.getUsers(
            page: page,
            pageSize: pageSize,
          )).thenAnswer((_) async => const Right(UsersResponseModel(
            hasMore: true,
            items: [],
          )));

      // Act
      final result = await useCase.call(
        page: page,
        pageSize: pageSize,
      );

      result.getOrElse(() => usersResponse);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw UnimplementedError()), usersResponse);
      expect(result, const Right<Failure, UsersResponseModel>(usersResponse));
      verify(() => mockRepository.getUsers(
            page: page,
            pageSize: pageSize,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository throws an exception', () async {
      // Arrange
      when(() => mockRepository.getUsers(
            page: page,
            pageSize: pageSize,
          )).thenThrow(Exception());

      // Act
      final result = await useCase.call(
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isLeft(), true);
      expect(
          result,
          const Left<Failure, UsersResponseModel>(DataSourceFailure(
              message: 'An error occurred while trying to get users')));
      verify(() => mockRepository.getUsers(
            page: page,
            pageSize: pageSize,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

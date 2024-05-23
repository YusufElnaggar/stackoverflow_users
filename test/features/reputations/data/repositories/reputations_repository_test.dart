import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackoverflow_users/core/domain/models/failures.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';
import 'package:stackoverflow_users/features/reputations/data/repositories/reputations_repository.dart';
import 'package:stackoverflow_users/features/reputations/data/data_source/remote_reputations_data_source.dart';

class RemoteReputationsDataSourceMock extends Mock
    implements RemoteReputationsDataSource {}

void main() {
  late ReputationsRespositoryImpl reputationsRepository;
  late RemoteReputationsDataSourceMock remoteReputationsDataSource;

  setUp(() {
    remoteReputationsDataSource = RemoteReputationsDataSourceMock();
    reputationsRepository =
        ReputationsRespositoryImpl(remoteReputationsDataSource);
  });

  group('getReputations', () {
    const userId = 1;
    const page = 1;
    const pageSize = 30;

    test(
        'should return ReputationsResponseModel when the request is successful',
        () async {
      // Arrange
      const responseModel = ReputationsResponseModel(
        hasMore: true,
        items: [],
      );
      when(() => remoteReputationsDataSource.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          )).thenAnswer((_) async => const Right(responseModel));

      // Act
      final result = await reputationsRepository.getReputations(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isRight(), true);
      expect(result,
          const Right<Failure, ReputationsResponseModel>(responseModel));
      verify(() => remoteReputationsDataSource.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          ));
      verifyNoMoreInteractions(remoteReputationsDataSource);
    });

    test('should return a Left with Failure when the request fails', () async {
      // Arrange
      const failure = ServerFailure();
      when(() => remoteReputationsDataSource.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await reputationsRepository.getReputations(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result, const Left<Failure, ReputationsResponseModel>(failure));
      verify(() => remoteReputationsDataSource.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          ));
      verifyNoMoreInteractions(remoteReputationsDataSource);
    });

    test('should return a Left with DataSourceFailure when an exception occurs',
        () async {
      // Arrange
      final exception = Exception('Test exception');
      when(() => remoteReputationsDataSource.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          )).thenThrow(exception);

      // Act
      final result = await reputationsRepository.getReputations(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isLeft(), true);
      verify(() => remoteReputationsDataSource.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          ));
      verifyNoMoreInteractions(remoteReputationsDataSource);
    });
  });
}

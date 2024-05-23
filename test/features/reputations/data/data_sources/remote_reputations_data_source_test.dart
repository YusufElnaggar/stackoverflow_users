import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackoverflow_users/core/data/remote/network_service.dart';
import 'package:stackoverflow_users/core/domain/models/failures.dart';
import 'package:stackoverflow_users/features/reputations/data/data_source/remote_reputations_data_source.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';

class NetworkServiceMock extends Mock implements NetworkService {}

void main() {
  late RemoteReputationsDataSource dataSource;
  late NetworkServiceMock networkService;

  setUp(() {
    networkService = NetworkServiceMock();
    dataSource = RemoteReputationsDataSourceImpl(networkService);
  });

  group('RemoteReputationsDataSource', () {
    const userId = 123;
    const page = 1;
    const pageSize = 30;

    test('should return reputations response model when successful', () async {
      // Arrange
      final responseJson = {
        'items': [],
        'has_more': false,
      };
      final expectedResponse = ReputationsResponseModel.fromJson(responseJson);
      when(() => networkService.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Right(responseJson));

      // Act
      final result = await dataSource.getReputations(
          userId: userId, page: page, pageSize: pageSize);

      // Assert
      expect(result, equals(Right(expectedResponse)));
      verify(() => networkService.get(any(),
          queryParameters: any(named: 'queryParameters'))).called(1);
      verifyNoMoreInteractions(networkService);
    });

    test('should return DataSourceFailure when an exception occurs', () async {
      // Arrange
      final exception = Exception('Test exception');
      when(() => networkService.get(any(),
          queryParameters: any(named: 'queryParameters'))).thenThrow(exception);

      // Act
      final result = await dataSource.getReputations(
          userId: userId, page: page, pageSize: pageSize);

      // Assert
      expect(result.isLeft(), true);
      expect(
          result,
          equals(Left<Failure, ReputationsResponseModel>(
              DataSourceFailure(message: exception.toString()))));
      verify(() => networkService.get(any(),
          queryParameters: any(named: 'queryParameters'))).called(1);
      verifyNoMoreInteractions(networkService);
    });

    test('should return WrongDataFailure when response format is incorrect',
        () async {
      // Arrange
      when(() => networkService.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => const Left(WrongDataFailure()));

      // Act
      final result = await dataSource.getReputations(
          userId: userId, page: page, pageSize: pageSize);

      // Assert
      expect(result.isLeft(), true);
      expect(
          result,
          equals(const Left<Failure, ReputationsResponseModel>(
              WrongDataFailure())));
      verify(() => networkService.get(any(),
          queryParameters: any(named: 'queryParameters'))).called(1);
      verifyNoMoreInteractions(networkService);
    });
  });
}

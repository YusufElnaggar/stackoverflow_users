import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackoverflow_users/core/domain/models/failures.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';
import 'package:stackoverflow_users/features/reputations/domain/usecases/get_user_reputations_use_case.dart';
import 'package:stackoverflow_users/features/reputations/domain/repositories/reputations_repository.dart';

class MockReputationsRepository extends Mock implements ReputationsRepository {}

void main() {
  late GetReputationsUseCase useCase;
  late MockReputationsRepository mockRepository;

  setUp(() {
    mockRepository = MockReputationsRepository();
    useCase = GetReputationsUseCase(mockRepository);
  });

  group('call', () {
    const userId = 1;
    const page = 1;
    const pageSize = 10;
    const reputationsResponse = ReputationsResponseModel(
      hasMore: true,
      items: [],
    );

    test('should return ReputationsResponseModel when repository succeeds',
        () async {
      // Arrange
      when(() => mockRepository.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          )).thenAnswer((_) async => const Right(ReputationsResponseModel(
            hasMore: true,
            items: [],
          )));

      // Act
      final result = await useCase.call(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isRight(), true);
      expect(result,
          const Right<Failure, ReputationsResponseModel>(reputationsResponse));
      verify(() => mockRepository.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository throws an exception', () async {
      // Arrange
      when(() => mockRepository.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          )).thenThrow(Exception());

      // Act
      final result = await useCase.call(
        userId: userId,
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.getReputations(
            userId: userId,
            page: page,
            pageSize: pageSize,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackoverflow_users/core/domain/models/failures.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_model.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';
import 'package:stackoverflow_users/features/reputations/domain/providers/reputations_providers.dart';
import 'package:stackoverflow_users/features/reputations/domain/usecases/get_user_reputations_use_case.dart';

class MockGetReputationsUseCase extends Mock implements GetReputationsUseCase {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  final getReputationsUseCase = MockGetReputationsUseCase();
  const userId = 123;

  ProviderContainer makeProviderContainer(
      MockGetReputationsUseCase getReputationsUseCase) {
    final container = ProviderContainer(
      overrides: [
        getReputationsUseCaseProvider.overrideWithValue(getReputationsUseCase),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncError<ReputationsResponseModel>(
        DataSourceFailure(message: 'errors'), StackTrace.empty));
    registerFallbackValue(const AsyncLoading<ReputationsResponseModel>());
  });
  group('fetch reputations ', () {
    test('initial state is AsyncLoading', () {
      // Arrange
      final container = makeProviderContainer(getReputationsUseCase);
      final listener = Listener<AsyncValue<ReputationsResponseModel>>();

      // Act
      container.listen(
        reputationsProviders(userId),
        listener.call,
        fireImmediately: true,
      );

      // Assert
      verify(() =>
          listener.call(null, const AsyncLoading<ReputationsResponseModel>()));
    });

    test('emits AsyncData when use case returns data', () async {
      // Arrange
      const response = ReputationsResponseModel(
        items: [ReputationsModel()],
        hasMore: false,
      );
      when(() => getReputationsUseCase.call(userId: userId, page: 1))
          .thenAnswer((_) async =>
              const Right<Failure, ReputationsResponseModel>(response));
      final container = makeProviderContainer(getReputationsUseCase);

      final listener = Listener<AsyncValue<ReputationsResponseModel>>();

      //  Act
      container.listen(
        reputationsProviders(userId),
        listener.call,
        fireImmediately: true,
      );
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verifyInOrder([
        () => listener.call(
              null,
              const AsyncLoading<ReputationsResponseModel>(),
            ),
        () => listener.call(const AsyncLoading<ReputationsResponseModel>(),
            const AsyncData<ReputationsResponseModel>(response)),
      ]);
    });

    test('emits AsyncError when use case returns error', () async {
      // Arrange
      const failure = DataSourceFailure(message: 'errors');
      when(() => getReputationsUseCase.call(userId: userId, page: 1))
          .thenAnswer((_) async =>
              const Left<Failure, ReputationsResponseModel>(failure));
      final container = makeProviderContainer(getReputationsUseCase);

      final listener = Listener<AsyncValue<ReputationsResponseModel>>();

      // Act
      container.listen(
        reputationsProviders(userId),
        listener.call,
        fireImmediately: true,
      );
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verifyInOrder([
        () => listener.call(
              null,
              const AsyncLoading<ReputationsResponseModel>(),
            ),
        () => listener.call(const AsyncLoading<ReputationsResponseModel>(),
            any(that: isA<AsyncError<ReputationsResponseModel>>())),
      ]);
    });
  });

  group('load more reputations', () {
    test('emits AsyncData with new data when use case returns data', () async {
      // Arrange
      const response = ReputationsResponseModel(
        items: [],
        hasMore: true,
      );
      when(() => getReputationsUseCase.call(userId: userId, page: 1))
          .thenAnswer((_) async =>
              const Right<Failure, ReputationsResponseModel>(response));
      when(() => getReputationsUseCase.call(userId: userId, page: 2))
          .thenAnswer((_) async =>
              const Right<Failure, ReputationsResponseModel>(response));
      final container = makeProviderContainer(getReputationsUseCase);

      final listener = Listener<AsyncValue<ReputationsResponseModel>>();
      // Act
      container.listen(
        reputationsProviders(userId),
        listener.call,
        fireImmediately: true,
      );
      await Future.delayed(const Duration(milliseconds: 100));
      final notifier = container.read(reputationsProviders(userId).notifier);
      await notifier.loadMoreReputations();
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verifyInOrder([
        () => listener.call(
              null,
              const AsyncLoading<ReputationsResponseModel>(),
            ),
        () => listener.call(const AsyncLoading<ReputationsResponseModel>(),
            const AsyncData<ReputationsResponseModel>(response)),
        () => listener.call(const AsyncData<ReputationsResponseModel>(response),
            const AsyncData<ReputationsResponseModel>(response)),
      ]);

      verify(() => getReputationsUseCase.call(userId: userId, page: 1))
          .called(1);
      verify(() => getReputationsUseCase.call(userId: userId, page: 2))
          .called(1);
      verifyNoMoreInteractions(getReputationsUseCase);
    });
  });
}

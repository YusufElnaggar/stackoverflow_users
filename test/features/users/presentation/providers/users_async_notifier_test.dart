import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackoverflow_users/core/domain/models/failures.dart';
import 'package:stackoverflow_users/features/users/data/models/user_item_model.dart';
import 'package:stackoverflow_users/features/users/data/models/users_response_model.dart';
import 'package:stackoverflow_users/features/users/domain/providers/users_providers.dart';
import 'package:stackoverflow_users/features/users/domain/usecases/get_users_use_case.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  final MockGetUsersUseCase mockGetUsersUseCase = MockGetUsersUseCase();

  ProviderContainer makeProviderContainer(MockGetUsersUseCase getUsersUseCase) {
    final container = ProviderContainer(
      overrides: [
        getUsersUseCaseProvider.overrideWithValue(getUsersUseCase),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    registerFallbackValue(const AsyncError<UsersResponseModel>(
        DataSourceFailure(message: 'errors'), StackTrace.empty));
    registerFallbackValue(const AsyncLoading<UsersResponseModel>());
  });

  group('UsersAsyncNotifier', () {
    test('build should call getUsers method', () async {
      // Arrange
      final container = makeProviderContainer(mockGetUsersUseCase);
      final listener = Listener<AsyncValue<UsersResponseModel>>();

      // Act
      container.listen(
        usersProvider,
        listener.call,
        fireImmediately: true,
      );

      // Assert
      verify(
          () => listener.call(null, const AsyncLoading<UsersResponseModel>()));
    });

    test('getUsers should update page and return users', () async {
      // Arrange
      const usersResponseModel =
          UsersResponseModel(items: [UserItemModel()], hasMore: false);
      when(() => mockGetUsersUseCase.call(page: 1)).thenAnswer((_) async =>
          const Right<Failure, UsersResponseModel>(usersResponseModel));
      final container = makeProviderContainer(mockGetUsersUseCase);
      final listener = Listener<AsyncValue<UsersResponseModel>>();

      // Act
      container.listen(
        usersProvider,
        listener.call,
        fireImmediately: true,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verifyInOrder([
        () => listener.call(null, const AsyncLoading<UsersResponseModel>()),
        () => listener.call(const AsyncLoading<UsersResponseModel>(),
            const AsyncData<UsersResponseModel>(usersResponseModel)),
      ]);
    });

    test('getUsers should throw an error if call fails', () async {
      // Arrange
      const failure = DataSourceFailure(message: 'errors');
      when(() => mockGetUsersUseCase.call(page: 1))
          .thenAnswer((_) async => const Left(failure));
      final container = makeProviderContainer(mockGetUsersUseCase);
      final listener = Listener<AsyncValue<UsersResponseModel>>();

      // Act
      container.listen(
        usersProvider,
        listener.call,
        fireImmediately: true,
      );
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verifyInOrder([
        () => listener.call(null, const AsyncLoading<UsersResponseModel>()),
        () => listener.call(const AsyncLoading<UsersResponseModel>(),
            any(that: isA<AsyncError<UsersResponseModel>>())),
      ]);
    });

    test('loadMoreUsers should update state with more users', () async {
      // Arrange
      const usersResponseModel = UsersResponseModel(
        items: [],
        hasMore: true,
      );
      when(() => mockGetUsersUseCase.call(page: 1)).thenAnswer((_) async =>
          const Right<Failure, UsersResponseModel>(usersResponseModel));
      when(() => mockGetUsersUseCase.call(page: 2)).thenAnswer((_) async =>
          const Right<Failure, UsersResponseModel>(usersResponseModel));
      final container = makeProviderContainer(mockGetUsersUseCase);
      final listener = Listener<AsyncValue<UsersResponseModel>>();
      final usersAsyncNotifier = container.read(usersProvider.notifier);

      // Act
      container.listen(
        usersProvider,
        listener.call,
        fireImmediately: true,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      await usersAsyncNotifier.loadMoreUsers();
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verifyInOrder([
        () => listener.call(null, const AsyncLoading<UsersResponseModel>()),
        () => listener.call(const AsyncLoading<UsersResponseModel>(),
            const AsyncData<UsersResponseModel>(usersResponseModel)),
        () => listener.call(
            const AsyncData<UsersResponseModel>(usersResponseModel),
            const AsyncData<UsersResponseModel>(usersResponseModel)),
      ]);

      verify(() => mockGetUsersUseCase.call(page: 1)).called(1);
      verify(() => mockGetUsersUseCase.call(page: 2)).called(1);
      verifyNoMoreInteractions(mockGetUsersUseCase);
    });
  });
}

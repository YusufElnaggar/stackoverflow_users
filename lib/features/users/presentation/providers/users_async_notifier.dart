import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/users_response_model.dart';
import '../../domain/providers/users_providers.dart';

class UsersAsyncNotifier extends AsyncNotifier<UsersResponseModel> {
  @override
  FutureOr<UsersResponseModel> build() {
    return getUsers();
  }

  int page = 1;

  Future<UsersResponseModel> getUsers() async {
    try {
      page = 1;
      final getUsersUseCase = ref.read(getUsersUseCaseProvider);
      final result = await getUsersUseCase.call(
        page: page,
      );
      return result.fold(
        (failure) => throw failure.message,
        (users) {
          page++;
          return users;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMoreUsers() async {
    try {
      final getUsersUseCase = ref.read(getUsersUseCaseProvider);
      final result = await getUsersUseCase.call(
        page: page,
      );
      return result.fold(
        (failure) => throw failure,
        (users) {
          final tempValue = state.value;
          page++;
          state = AsyncData(
            UsersResponseModel(
              items: [...(tempValue?.items ?? []), ...users.items],
              hasMore: users.hasMore,
            ),
          );
          return;
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}

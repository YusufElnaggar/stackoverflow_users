import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';

import '../../domain/providers/reputations_providers.dart';

class ReputationsAsyncNotifier
    extends AutoDisposeFamilyAsyncNotifier<ReputationsResponseModel, int> {
  @override
  FutureOr<ReputationsResponseModel> build(arg) {
    userId = arg;
    return getReputations();
  }

  late int userId;

  int page = 1;

  Future<ReputationsResponseModel> getReputations() async {
    try {
      page = 1;
      final getReputationsUseCase = ref.read(getReputationsUseCaseProvider);
      final result = await getReputationsUseCase.call(
        userId: userId,
        page: page,
      );
      return result.fold(
        (failure) => throw failure.message,
        (reputations) {
          page++;
          return reputations;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMoreReputations() async {
    try {
      final getReputationsUseCase = ref.read(getReputationsUseCaseProvider);
      final result = await getReputationsUseCase.call(
        userId: userId,
        page: page,
      );
      return result.fold(
        (failure) => throw failure,
        (reputations) {
          final tempValue = state.value;
          page++;
          state = AsyncValue.data(
            ReputationsResponseModel(
              items: [...(tempValue?.items ?? []), ...reputations.items],
              hasMore: reputations.hasMore,
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

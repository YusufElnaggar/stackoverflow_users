import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_response_model.dart';

import '../../../../core/data/remote/network_service.dart';
import '../../../../core/domain/providers/http_network_service_provider.dart';
import '../../data/data_source/remote_reputations_data_source.dart';
import '../../data/repositories/reputations_repository.dart';
import '../../presentation/providers/user_reputations_async_notifier.dart';
import '../usecases/get_user_reputations_use_case.dart';

final reputationsDataSourceProvider = Provider.family
    .autoDispose<RemoteReputationsDataSource, NetworkService>(
        (_, networkService) => RemoteReputationsDataSourceImpl(networkService));

final reputationsRepositoryProvider = Provider.autoDispose(
  (ref) {
    final networkService = ref.watch(httpNetworkServiceProvider);

    final RemoteReputationsDataSource remoteReputationsDataSource =
        ref.watch(reputationsDataSourceProvider(networkService));

    return ReputationsRespositoryImpl(remoteReputationsDataSource);
  },
);

final getReputationsUseCaseProvider = Provider.autoDispose(
  (ref) {
    final reputationsRepository = ref.watch(reputationsRepositoryProvider);

    return GetReputationsUseCase(reputationsRepository);
  },
);

final reputationsProviders = AsyncNotifierProvider.autoDispose
    .family<ReputationsAsyncNotifier, ReputationsResponseModel, int>(
  () {
    return ReputationsAsyncNotifier();
  },
);

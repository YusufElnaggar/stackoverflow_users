import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/network_service.dart';
import '../../../../core/domain/providers/http_network_service_provider.dart';
import '../../data/data_source/remote_users_data_source.dart';
import '../../data/models/user_item_model.dart';
import '../../data/models/users_response_model.dart';
import '../../data/repositories/users_repository.dart';
import '../../presentation/providers/bookmarked_users_provider.dart';
import '../../presentation/providers/users_async_notifier.dart';
import '../usecases/get_users_use_case.dart';

final usersDataSourceProvider = Provider.family
    .autoDispose<RemoteUsersDataSource, NetworkService>(
        (_, networkService) => RemoteUsersDataSourceImpl(networkService));

final usersRepositoryProvider = Provider.autoDispose(
  (ref) {
    final networkService = ref.watch(httpNetworkServiceProvider);

    final RemoteUsersDataSource remoteUsersDataSource =
        ref.watch(usersDataSourceProvider(networkService));

    return UsersRespositoryImpl(remoteUsersDataSource);
  },
);

final getUsersUseCaseProvider = Provider.autoDispose(
  (ref) {
    final usersRepository = ref.watch(usersRepositoryProvider);

    return GetUsersUseCase(usersRepository);
  },
);

final usersProvider =
    AsyncNotifierProvider<UsersAsyncNotifier, UsersResponseModel>(
  () {
    return UsersAsyncNotifier();
  },
);

final bookmarkedUsersProvider =
    AsyncNotifierProvider<BookmarkedUsersProvider, List<UserItemModel>>(
  () => BookmarkedUsersProvider(),
);

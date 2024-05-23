import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackoverflow_users/core/data/local/storage_service.dart';
import 'package:stackoverflow_users/services/user_bookmark_cache_service/domain/use_cases/debookmark_user_usecase.dart';

import '../../data/data_sources/user_bookmark_local_datasource.dart';
import '../../data/repositories/users_bookmarked_cache_repository_impl.dart';
import '../use_cases/bookmark_user_usecase.dart';
import '../use_cases/get_bookmarked_users_usecase.dart';
import 'share_prefrences_storage_service_provider.dart';

final usersBookmarkedLocalDataSourceProvider =
    Provider.family.autoDispose<UserLocalDataSource, StorageService>(
  (ref, storageService) => UserLocalDataSource(storageService),
);

final usersBookmarkedCacheRepositoryProvider = Provider.autoDispose(
  (ref) {
    final storageService = ref.read(sharedPrefsServiceProvider);
    final usersBookmarkedLocalDataSource =
        ref.read(usersBookmarkedLocalDataSourceProvider(storageService));
    return UsersBookmarkedCacheRepositoryImpl(
        userDataSource: usersBookmarkedLocalDataSource);
  },
);

final getBookmarkedUsersUsecaseProvider = Provider.autoDispose(
  (ref) {
    final usersBookmarkedCacheRepository =
        ref.read(usersBookmarkedCacheRepositoryProvider);
    return GetBookmarkedUsersUseCase(usersBookmarkedCacheRepository);
  },
);

final bookmarkUserUsecaseProvider = Provider.autoDispose(
  (ref) {
    final usersBookmarkedCacheRepository =
        ref.read(usersBookmarkedCacheRepositoryProvider);
    return BookmarkedUserUseCase(usersBookmarkedCacheRepository);
  },
);

final debookmarkUserUsecaseProvider = Provider.autoDispose(
  (ref) {
    final usersBookmarkedCacheRepository =
        ref.read(usersBookmarkedCacheRepositoryProvider);
    return DebookmarkedUserUseCase(usersBookmarkedCacheRepository);
  },
);

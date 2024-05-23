import '../../domain/repositories/users_bookmarked_cache_repository.dart';
import '../data_sources/user_bookmark_local_datasource.dart';

class UsersBookmarkedCacheRepositoryImpl
    implements UsersBookmarkedCacheRepository {
  final UserDataSource userDataSource;

  UsersBookmarkedCacheRepositoryImpl({required this.userDataSource});

  @override
  Future<bool> bookmarkUser(int userId) {
    return userDataSource.bookmarkUser(userId);
  }

  @override
  Future<bool> debookmarkUser(int userId) {
    return userDataSource.debookmarkUser(userId);
  }

  @override
  Future<List<int>> fetcBookmarkedhUser() {
    return userDataSource.fetcBookmarkedhUser();
  }
}

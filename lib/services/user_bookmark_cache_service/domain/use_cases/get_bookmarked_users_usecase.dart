import '../repositories/users_bookmarked_cache_repository.dart';

class GetBookmarkedUsersUseCase {
  final UsersBookmarkedCacheRepository _usersBookmarkedCacheRepository;

  GetBookmarkedUsersUseCase(this._usersBookmarkedCacheRepository);

  Future<List<int>> call() async {
    return _usersBookmarkedCacheRepository.fetcBookmarkedhUser();
  }
}

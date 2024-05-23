import '../repositories/users_bookmarked_cache_repository.dart';

class DebookmarkedUserUseCase {
  final UsersBookmarkedCacheRepository _usersBookmarkedCacheRepository;

  DebookmarkedUserUseCase(this._usersBookmarkedCacheRepository);

  Future<bool> call(int userId) async {
    return _usersBookmarkedCacheRepository.debookmarkUser(userId);
  }
}

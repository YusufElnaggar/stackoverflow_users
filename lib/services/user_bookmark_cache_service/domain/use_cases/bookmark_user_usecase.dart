import '../repositories/users_bookmarked_cache_repository.dart';

class BookmarkedUserUseCase {
  final UsersBookmarkedCacheRepository _usersBookmarkedCacheRepository;

  BookmarkedUserUseCase(this._usersBookmarkedCacheRepository);

  Future<bool> call(int userId) async {
    return _usersBookmarkedCacheRepository.bookmarkUser(userId);
  }
}

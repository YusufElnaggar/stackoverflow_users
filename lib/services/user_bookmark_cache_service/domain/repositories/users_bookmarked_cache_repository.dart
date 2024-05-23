abstract class UsersBookmarkedCacheRepository {
  Future<List<int>> fetcBookmarkedhUser();
  Future<bool> bookmarkUser(int userId);
  Future<bool> debookmarkUser(int userId);
}

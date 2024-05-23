import 'package:stackoverflow_users/core/utils/constants/global_constants.dart';

import '../../../../core/data/local/storage_service.dart';

abstract class UserDataSource {
  String get storageKey;

  Future<List<int>> fetcBookmarkedhUser();
  Future<bool> bookmarkUser(int userId);
  Future<bool> debookmarkUser(int userId);
}

class UserLocalDataSource implements UserDataSource {
  UserLocalDataSource(this.storageService);

  final StorageService storageService;
  @override
  String get storageKey => userBookmarksLocalStorageKey;

  @override
  Future<bool> bookmarkUser(int userId) async {
    final result = await storageService.has(storageKey);
    if (!result) {
      return await storageService.set(storageKey, userId.toString());
    }
    List<int> bookmarkedUsers = await fetcBookmarkedhUser();
    bookmarkedUsers = [...bookmarkedUsers, userId];
    return await storageService.set(storageKey, bookmarkedUsers.join(','));
  }

  @override
  Future<bool> debookmarkUser(int userId) async {
    final result = await storageService.has(storageKey);
    if (!result) {
      return false;
    } else {
      List<int> bookmarkedUsers = await fetcBookmarkedhUser();
      bookmarkedUsers.remove(userId);
      return await storageService.set(storageKey, bookmarkedUsers.join(','));
    }
  }

  @override
  Future<List<int>> fetcBookmarkedhUser() async {
    final result = await storageService.has(storageKey);

    if (!result) {
      return [];
    }
    final bookmarkedUsers = await storageService.get(storageKey) as String;
    return bookmarkedUsers
        .split(',')
        .where((element) => int.tryParse(element) != null)
        .map((mapElement) => int.parse(mapElement))
        .toList();
  }
}

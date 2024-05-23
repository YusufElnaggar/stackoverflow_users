import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackoverflow_users/services/user_bookmark_cache_service/domain/providers/user_bookmark_cache_providers.dart';

import '../../data/models/user_item_model.dart';
import '../../domain/providers/users_providers.dart';

class BookmarkedUsersProvider extends AsyncNotifier<List<UserItemModel>> {
  @override
  FutureOr<List<UserItemModel>> build() {
    return getUsers();
  }

  Future<List<UserItemModel>> getUsers() async {
    try {
      final result = await ref.read(getBookmarkedUsersUsecaseProvider).call();
      final users = await ref.watch(usersProvider.selectAsync((data) => data));
      final bookmarkedUsers = users.items
          .where((element) => result.contains(element.userId))
          .toList();
      return bookmarkedUsers;
    } catch (e) {
      throw Exception('Failed to get bookmarked users');
    }
  }

  Future<void> toggle(
      {required bool isbookmarked, required UserItemModel user}) async {
    if (isbookmarked) {
      await remove(user);
    } else {
      await add(user);
    }
  }

  Future<void> add(UserItemModel user) async {
    final result =
        await ref.read(bookmarkUserUsecaseProvider).call(user.userId!);
    if (result) {
      _addUser(user);
    } else {
      throw Exception('Failed to bookmark user');
    }
  }

  _addUser(UserItemModel user) {
    try {
      // final users = state.value ?? [];
      final users = [...state.value ?? <UserItemModel>[], user];
      state = AsyncData(users);
      // users.add(user);
      // state = AsyncValue.data(users);
    } catch (e) {
      throw Exception('Failed to add user');
    }
  }

  Future<void> remove(UserItemModel user) async {
    final result =
        await ref.read(debookmarkUserUsecaseProvider).call(user.userId!);
    if (result) {
      _removeUser(user);
    } else {
      throw Exception('Failed to debookmark user');
    }
  }

  _removeUser(UserItemModel user) {
    final users = state.value ?? [];
    users.removeWhere((element) => element.userId == user.userId);
    state = AsyncData(users);
  }
}

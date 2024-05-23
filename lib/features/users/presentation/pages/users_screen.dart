import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/all_users_list_wiget.dart';
import '../widgets/bookmarked_users_list_wiget.dart';

class UsersScreen extends HookConsumerWidget {
  static const routeName = 'usersScreen';

  static Route<void> route() {
    return MaterialPageRoute(
        builder: (context) {
          return const UsersScreen();
        },
        settings: const RouteSettings(name: routeName));
  }

  const UsersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'All Users',
              ),
              Tab(
                text: 'Bookmarked Users',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllUsersListWidget(),
            BookmarkedUsersListWidget(),
          ],
        ),
      ),
    );
  }
}

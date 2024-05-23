import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/presentation/widgets/empty_list_widget.dart';
import '../../../../core/presentation/widgets/error_widget.dart';
import '../../domain/providers/users_providers.dart';
import '../widgets/user_item_widget.dart';

class AllUsersListWidget extends HookConsumerWidget {
  const AllUsersListWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool loadingMore = false;
    final usersNotifier = ref.watch(usersProvider);
    final bookmarkedUsers = ref.watch(bookmarkedUsersProvider).value ?? [];
    final scrollController = useScrollController();
    return usersNotifier.when(
      skipLoadingOnRefresh: false,
      data: (users) {
        return users.items.isEmpty
            ? const EmptyListWidget(
                title: 'No users found',
                subtitle: 'Please try again later',
              )
            : ListView.separated(
                controller: scrollController
                  ..addListener(() async {
                    if (scrollController.position.pixels ==
                            scrollController.position.maxScrollExtent &&
                        users.hasMore &&
                        !loadingMore) {
                      loadingMore = true;
                      await ref.read(usersProvider.notifier).loadMoreUsers();
                      loadingMore = false;
                    }
                  }),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: users.items.length + (users.hasMore ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == users.items.length) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  final user = users.items[index].copyWith(
                    isBookmarked: bookmarkedUsers.contains(users.items[index]),
                  );
                  return UserItemWidget(
                    user: user,
                  );
                },
              );
      },
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      error: (error, stackTrace) => ErrorTextWidget(
          errorMassage: error.toString(),
          function: () async {
            if (!usersNotifier.isRefreshing) {
              ref.invalidate(usersProvider);
            }
          }),
    );
  }
}

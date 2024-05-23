import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/presentation/widgets/empty_list_widget.dart';
import '../../../../core/presentation/widgets/error_widget.dart';
import '../../domain/providers/users_providers.dart';
import '../widgets/user_item_widget.dart';

class BookmarkedUsersListWidget extends HookConsumerWidget {
  const BookmarkedUsersListWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedUsersNotifier = ref.watch(bookmarkedUsersProvider);
    return bookmarkedUsersNotifier.when(
      skipLoadingOnRefresh: false,
      data: (users) {
        return users.isEmpty
            ? const EmptyListWidget(
                title: 'No bookmarked users',
                subtitle:
                    'You can bookmark users by tapping on the bookmark icon',
              )
            : ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: users.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == users.length) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  final user = users[index].copyWith(
                    isBookmarked: true,
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
            if (!bookmarkedUsersNotifier.isRefreshing) {
              ref.invalidate(bookmarkedUsersProvider);
            }
          }),
    );
  }
}

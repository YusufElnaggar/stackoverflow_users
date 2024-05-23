import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/presentation/widgets/empty_list_widget.dart';
import '../../../../core/presentation/widgets/error_widget.dart';
import '../../domain/providers/reputations_providers.dart';
import '../widgets/user_reputation_widget.dart';

class UserReputationsScreen extends HookConsumerWidget {
  static const routeName = 'userReputaionsScreen';

  static Route<void> route({required int userId}) {
    return MaterialPageRoute(
        builder: (context) {
          return UserReputationsScreen(
            userId: userId,
          );
        },
        settings: const RouteSettings(name: routeName));
  }

  final int userId;
  const UserReputationsScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool loadingMore = false;
    final userReputationsNotifier = ref.watch(reputationsProviders(userId));
    final scrollController = useScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Reputations'),
      ),
      body: userReputationsNotifier.when(
        skipLoadingOnRefresh: false,
        data: (reputations) {
          return reputations.items.isEmpty
              ? const EmptyListWidget(
                  title: 'No reputations found',
                  subtitle: 'Please try again later',
                )
              : ListView.separated(
                  controller: scrollController
                    ..addListener(
                      () async {
                        try {
                          if (scrollController.position.pixels ==
                                  scrollController.position.maxScrollExtent &&
                              reputations.hasMore &&
                              !loadingMore) {
                            loadingMore = true;

                            await ref
                                .read(reputationsProviders(userId).notifier)
                                .loadMoreReputations();

                            loadingMore = false;
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                    ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount:
                      reputations.items.length + (reputations.hasMore ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    if (index == reputations.items.length) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    final reputation = reputations.items[index];
                    return UserReputationWidget(
                      reputation: reputation,
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
              if (!userReputationsNotifier.isRefreshing) {
                ref.invalidate(reputationsProviders(userId));
              }
            }),
      ),
    );
  }
}

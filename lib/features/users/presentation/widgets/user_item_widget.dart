import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:stackoverflow_users/core/utils/extensions/date_time_extension.dart';
import 'package:stackoverflow_users/core/utils/ui_utils.dart';
import 'package:stackoverflow_users/features/reputations/presentation/pages/user_reputations_screen.dart';
import 'package:stackoverflow_users/features/users/data/models/user_item_model.dart';
import 'package:stackoverflow_users/gen/assets.gen.dart';

import '../../domain/providers/users_providers.dart';

class UserItemWidget extends HookConsumerWidget {
  final UserItemModel user;

  const UserItemWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState<bool>(false);
    final isBookmarked = useState<bool>(user.isBookmarked);
    return GestureDetector(
      onTap: () {
        navigateTo(context, UserReputationsScreen.route(userId: user.userId!));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 7.h,
              width: 7.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: CachedNetworkImage(
                  imageUrl: user.profileImage ?? '',
                  errorWidget: (_, __, ___) => Image.asset(
                    Assets.logo.path,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(user.displayName ?? 'User'),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                  if (user.reputation != null) _reputationWidget(),
                  if (user.location != null) _locationWidget(),
                  if (user.creationDate != null) _creationDateWidget(),
                ],
              ),
            ),
            const SizedBox(width: 15),
            IconButton(
              icon: isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Icon(
                      isBookmarked.value
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                    ),
              onPressed: () async {
                try {
                  if (isLoading.value) return;
                  isLoading.value = true;
                  await ref
                      .read(bookmarkedUsersProvider.notifier)
                      .toggle(isbookmarked: isBookmarked.value, user: user);
                  isLoading.value = false;
                  isBookmarked.value = !isBookmarked.value;
                } catch (error) {
                  isLoading.value = false;
                  debugPrint(error.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _reputationWidget() {
    return Row(
      children: [
        const Icon(
          Icons.star,
          size: 12,
          color: Colors.grey,
        ),
        const SizedBox(width: 5),
        Expanded(child: Text('Reputation: ${user.reputation}')),
      ],
    );
  }

  Row _locationWidget() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 12,
          color: Colors.grey,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            user.location!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _creationDateWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.calendar_today,
          size: 12,
          color: Colors.grey,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: AutoSizeText(
            'Member for ${user.creationDate!.formatToYearsMonths()}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

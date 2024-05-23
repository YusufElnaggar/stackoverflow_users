import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stackoverflow_users/core/utils/extensions/date_time_extension.dart';
import 'package:stackoverflow_users/features/reputations/data/models/reputations_model.dart';

class UserReputationWidget extends StatelessWidget {
  final ReputationsModel reputation;

  const UserReputationWidget({
    super.key,
    required this.reputation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reputation.reputationHistoryType != null)
                _historyTypeWidget(),
              if (reputation.postId != null) _postIdWidget(),
              if (reputation.reputationChange != null)
                _reputationChangeWidget(),
              if (reputation.creationDate != null) _creationDateWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Text _historyTypeWidget() {
    return Text(
      (reputation.reputationHistoryType ?? '').split('_').join(' '),
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _postIdWidget() {
    return Row(
      children: [
        Text(
          'Post : ${reputation.postId}',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Row _reputationChangeWidget() {
    Color color(int change) {
      switch (change) {
        case > 0:
          return Colors.green;
        case < 0:
          return Colors.red;
        case 0:
          return Colors.grey;
        default:
          return Colors.grey;
      }
    }

    IconData icon(int change) {
      switch (change) {
        case > 0:
          return Icons.arrow_upward_rounded;
        case < 0:
          return Icons.arrow_downward_rounded;
        case 0:
          return Icons.arrow_forward_rounded;
        default:
          return Icons.arrow_forward_rounded;
      }
    }

    return Row(
      children: [
        Icon(
          icon(reputation.reputationChange ?? 0),
          size: 10.sp,
          color: color(reputation.reputationChange ?? 0),
        ),
        const SizedBox(width: 5),
        Text(
          reputation.reputationChange.toString(),
          style: TextStyle(
            fontSize: 10.sp,
            color: color(reputation.reputationChange ?? 0),
          ),
        ),
      ],
    );
  }

  Row _creationDateWidget() {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 9.sp,
          color: Colors.black,
        ),
        const SizedBox(width: 5),
        Text(
          reputation.creationDate!.formatToTimeDayMonthYear(),
          style: TextStyle(
            fontSize: 9.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

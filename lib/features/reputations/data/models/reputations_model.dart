import 'package:equatable/equatable.dart';

class ReputationsModel extends Equatable {
  final int? userId;
  final int? postId;
  final DateTime? creationDate;
  final int? reputationChange;
  final String? reputationHistoryType;

  const ReputationsModel({
    this.postId,
    this.reputationChange,
    this.creationDate,
    this.userId,
    this.reputationHistoryType,
  });

  ReputationsModel copyWith({
    int? postId,
    int? reputationChange,
    DateTime? creationDate,
    int? userId,
    String? reputationHistoryType,
  }) =>
      ReputationsModel(
        postId: postId ?? this.postId,
        reputationChange: reputationChange ?? this.reputationChange,
        creationDate: creationDate ?? this.creationDate,
        userId: userId ?? this.userId,
        reputationHistoryType:
            reputationHistoryType ?? this.reputationHistoryType,
      );

  factory ReputationsModel.fromJson(Map<String, dynamic> json) =>
      ReputationsModel(
        userId: json["user_id"],
        postId: json["post_id"],
        reputationChange: json["reputation_change"],
        reputationHistoryType: json["reputation_history_type"],
        creationDate: json["creation_date"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["creation_date"] * 1000,
                isUtc: true),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "post_id": postId,
        "reputation_change": reputationChange,
        "creation_date": creationDate,
        "reputation_history_type": reputationHistoryType,
      };

  @override
  List<Object?> get props => [
        userId,
        postId,
        reputationChange,
        creationDate,
        reputationHistoryType,
      ];
}

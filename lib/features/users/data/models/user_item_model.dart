import 'package:equatable/equatable.dart';

class UserItemModel extends Equatable {
  final int? userId;
  final int? accountId;
  final int? reputation;
  final int? reputationChangeWeek;
  final String? location;
  final DateTime? creationDate;
  final String? profileImage;
  final String? displayName;
  final bool isBookmarked;

  const UserItemModel({
    this.accountId,
    this.reputationChangeWeek,
    this.reputation,
    this.creationDate,
    this.userId,
    this.location,
    this.profileImage,
    this.displayName,
    this.isBookmarked = false,
  });

  UserItemModel copyWith({
    int? accountId,
    int? reputationChangeWeek,
    int? reputation,
    DateTime? creationDate,
    int? userId,
    String? location,
    String? profileImage,
    String? displayName,
    bool? isBookmarked,
  }) =>
      UserItemModel(
        accountId: accountId ?? this.accountId,
        reputationChangeWeek: reputationChangeWeek ?? this.reputationChangeWeek,
        reputation: reputation ?? this.reputation,
        creationDate: creationDate ?? this.creationDate,
        userId: userId ?? this.userId,
        location: location ?? this.location,
        profileImage: profileImage ?? this.profileImage,
        displayName: displayName ?? this.displayName,
        isBookmarked: isBookmarked ?? this.isBookmarked,
      );

  factory UserItemModel.fromJson(Map<String, dynamic> json) => UserItemModel(
        accountId: json["account_id"],
        reputationChangeWeek: json["reputation_change_week"],
        reputation: json["reputation"],
        creationDate: json["creation_date"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["creation_date"] * 1000,
                isUtc: true),
        userId: json["user_id"],
        location: json["location"],
        profileImage: json["profile_image"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "reputation_change_week": reputationChangeWeek,
        "reputation": reputation,
        "creation_date": creationDate,
        "user_id": userId,
        "location": location,
        "profile_image": profileImage,
        "display_name": displayName,
      };

  @override
  List<Object?> get props => [
        accountId,
        reputationChangeWeek,
        reputation,
        creationDate,
        userId,
        location,
        profileImage,
        displayName,
        isBookmarked,
      ];
}

import 'package:equatable/equatable.dart';

import 'user_item_model.dart';

class UsersResponseModel extends Equatable {
  final List<UserItemModel> items;
  final bool hasMore;

  const UsersResponseModel({
    required this.items,
    required this.hasMore,
  });

  UsersResponseModel copyWith({
    List<UserItemModel>? items,
    bool? hasMore,
  }) =>
      UsersResponseModel(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
      );
  factory UsersResponseModel.fromJson(Map<String, dynamic> json) =>
      UsersResponseModel(
        items: List<UserItemModel>.from(
            json["items"].map((x) => UserItemModel.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "items":
            List<dynamic>.from(items.map((x) => (x as UserItemModel).toJson())),
        "has_more": hasMore,
      };

  @override
  List<Object?> get props => [items, hasMore];
}

import 'package:equatable/equatable.dart';

import 'reputations_model.dart';

class ReputationsResponseModel extends Equatable {
  final List<ReputationsModel> items;
  final bool hasMore;

  const ReputationsResponseModel({
    required this.items,
    required this.hasMore,
  });

  ReputationsResponseModel copyWith({
    List<ReputationsModel>? items,
    bool? hasMore,
  }) =>
      ReputationsResponseModel(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
      );
  factory ReputationsResponseModel.fromJson(Map<String, dynamic> json) =>
      ReputationsResponseModel(
        items: List<ReputationsModel>.from(
            json["items"].map((x) => ReputationsModel.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(
            items.map((x) => (x as ReputationsModel).toJson())),
        "has_more": hasMore,
      };

  @override
  List<Object?> get props => [items, hasMore];
}

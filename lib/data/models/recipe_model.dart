import 'package:recipe_app/data/models/comment_model.dart';

import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@JsonSerializable()
class RecipeModel {
  String id;
  String creatorId;
  String title;
  String ingredients;
  String stagesOfPreparation;
  String categoryId;
  int cookingTime;
  int likesCount;
  List<CommentModel> comments;
  String imageUrl;
  String videoUrl;
  String date;

  RecipeModel({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.ingredients,
    required this.stagesOfPreparation,
    required this.categoryId,
    required this.cookingTime,
    required this.likesCount,
    required this.comments,
    required this.imageUrl,
    required this.videoUrl,
    required this.date
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return _$RecipeModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RecipeModelToJson(this);
  }
}

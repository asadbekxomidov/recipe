// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) => RecipeModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      title: json['title'] as String,
      ingredients: json['ingredients'] as String,
      stagesOfPreparation: json['stagesOfPreparation'] as String,
      categoryId: json['categoryId'] as String,
      cookingTime: (json['cookingTime'] as num).toInt(),
      likesCount: (json['likesCount'] as num).toInt(),
      comments: json['comments'] == null?[] :(json['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl']==null?'':json['imageUrl'] as String,
      videoUrl: json['videoUrl']==null?'':json['videoUrl'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$RecipeModelToJson(RecipeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'title': instance.title,
      'ingredients': instance.ingredients,
      'stagesOfPreparation': instance.stagesOfPreparation,
      'categoryId': instance.categoryId,
      'cookingTime': instance.cookingTime,
      'likesCount': instance.likesCount,
      'comments': instance.comments,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'date': instance.date,
    };

import 'dart:io';

sealed class RecipeManagerEvent {}

class AddRecipe extends RecipeManagerEvent {
  String creatorId;
  String title;
  String ingredients;
  String stagesOfPreparation;
  String category;
  int cookingTime;
  File? imageFile;
  File? videoFile;

  AddRecipe({
    required this.creatorId,
    required this.title,
    required this.ingredients,
    required this.stagesOfPreparation,
    required this.category,
    required this.cookingTime,
    required this.imageFile,
    required this.videoFile,
  });
}

class EditRecipe extends RecipeManagerEvent {
  String id;
  String creatorId;
  String title;
  String ingredients;
  String stagesOfPreparation;
  String categoryId;
  int cookingTime;
  String imageUrl;
  String videoUrl;
  File? imageFile;
  File? videoFile;

  EditRecipe({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.ingredients,
    required this.stagesOfPreparation,
    required this.categoryId,
    required this.cookingTime,
    required this.imageUrl,
    required this.videoUrl,
    required this.imageFile,
    required this.videoFile,
  });
}

import 'dart:io';

sealed class UserEvent {}

final class UpdateUserName extends UserEvent {
  final String newName;
  final String userId;
  UpdateUserName({
    required this.newName,
    required this.userId,
  });
}

final class UpdateUserBio extends UserEvent {
  final String newBio;
  final String userId;

  UpdateUserBio({
    required this.newBio,
    required this.userId,
  });
}

final class AddSavedRecipe extends UserEvent {
  final String userId;
  final List savedRecipe;

  AddSavedRecipe({
    required this.userId,
    required this.savedRecipe,
  });
}

final class AddLikedRecipe extends UserEvent {
  final bool likeCheck;
  final String userId;
  final String recipeId;
  final List savedRecipe;

  AddLikedRecipe({
    required this.likeCheck,
    required this.userId,
    required this.recipeId,
    required this.savedRecipe,
  });
}

final class UpdateUserPhoto extends UserEvent {
  final File image;
  final String userId;
  UpdateUserPhoto({
    required this.image,
    required this.userId,
  });
}

final class GetUserEvent extends UserEvent {
  final String? userId;
  GetUserEvent(this.userId);
}

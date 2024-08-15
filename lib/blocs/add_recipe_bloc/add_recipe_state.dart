sealed class AddRecipeState {}

class RecipeInitialState extends AddRecipeState {}

class RecipeUploadingState extends AddRecipeState {}

class RecipeUploadedState extends AddRecipeState {}

class RecipeErrorState extends AddRecipeState {
  final String error;
  RecipeErrorState({required this.error});
}

import 'package:recipe_app/data/models/recipe_model.dart';

sealed class RecipesState {}

class RecipesInitialState extends RecipesState {}

class RecipesLoadingState extends RecipesState {}

class RecipesLoadedState extends RecipesState {
  List<RecipeModel> recipes;

  RecipesLoadedState({required this.recipes});
}

class RecipesErrorState extends RecipesState {
  final String error;

  RecipesErrorState({required this.error});
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_event.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_state.dart';
import 'package:recipe_app/data/services/recipes_dio_service.dart';

class AddRecipeBloc extends Bloc<RecipeManagerEvent, AddRecipeState> {
  AddRecipeBloc() : super(RecipeInitialState()) {
    on<AddRecipe>(_onAddRecipe);
    on<EditRecipe>(_onEditRecipe);
  }

  void _onAddRecipe(AddRecipe event, emit) async {
    emit(RecipeUploadingState());
    try {
      final recipesDioService = RecipesDioService();
      await recipesDioService.addRecipe(
          event.creatorId,
          event.title,
          event.ingredients,
          event.stagesOfPreparation,
          event.category,
          event.cookingTime,
          event.imageFile,
          event.videoFile);
      emit(RecipeUploadedState());
    } catch (error) {
      emit(RecipeErrorState(error: error.toString()));
    }
  }

  void _onEditRecipe(EditRecipe event, emit) {
    emit(RecipeUploadingState());
    try {
      final recipesDioService = RecipesDioService();
      recipesDioService.editRecipe(
          event.id,
          event.title,
          event.ingredients,
          event.stagesOfPreparation,
          event.categoryId,
          event.cookingTime,
          event.imageUrl,
          event.videoUrl,
          event.imageFile,
          event.videoFile);
      emit(RecipeUploadedState());
    } catch (error) {
      emit(RecipeErrorState(error: error.toString()));
    }
  }
}

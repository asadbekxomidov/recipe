import 'package:bloc/bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/services/recipes_dio_service.dart';
import 'package:recipe_app/utils/current_user.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final RecipesDioService recipesDioService;

  RecipesBloc({required this.recipesDioService})
      : super(RecipesInitialState()) {
    on<GetRecipesEvent>(_onFetchRecipes);
    on<DeleteRecipeEvent>(_onDeleteRecipe);
    on<GetRecipeById>(_onGetRecipeById);
  }

  void _onGetRecipeById(GetRecipeById event, emit) async {
    emit(RecipesLoadingState());
    try {
      final recipesDioService = RecipesDioService();
      List<RecipeModel> recipes =
          await recipesDioService.getRecipesByUserId(event.userId);
      emit(RecipesLoadedState(recipes: recipes));
    } catch (error) {
      emit(RecipesErrorState(error: error.toString()));
    }
  }

  void _onFetchRecipes(GetRecipesEvent event, emit) async {
    emit(RecipesLoadingState());

    try {
      final List<RecipeModel> recipes = await recipesDioService.fetchRecipes();
      emit(RecipesLoadedState(recipes: recipes));
    } catch (error) {
      emit(RecipesErrorState(error: error.toString()));
    }
  }

  void _onDeleteRecipe(DeleteRecipeEvent event, emit) async {
    emit(RecipesLoadingState());
    try {
      await recipesDioService.deleteRecipe(event.id);
      emit(RecipesLoadedState(recipes: await recipesDioService.fetchRecipes()));
      add(GetRecipeById(userId: CurrentUser.currentUser!.localId!));
    } catch (error) {
      emit(RecipesErrorState(error: error.toString()));
    }
  }
}

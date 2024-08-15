import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/services/recipes_dio_service.dart';
import 'package:mocktail/mocktail.dart';

class MockRecipesDioService extends Mock implements RecipesDioService {}

void main() {
  late RecipesBloc recipesBloc;
  late MockRecipesDioService mockRecipesDioService;

  setUp(() {
    mockRecipesDioService = MockRecipesDioService();
    recipesBloc = RecipesBloc(recipesDioService: mockRecipesDioService);
  });

  group('RecipesBloc', () {
    final recipeModel = RecipeModel(
      id: '1',
      creatorId: '1',
      title: 'Test Recipe',
      ingredients: 'Test Ingredients',
      stagesOfPreparation: 'Test Preparation',
      categoryId: 'Test Category',
      cookingTime: 30,
      likesCount: 10,
      comments: [],
      imageUrl: 'https://example.com/image.jpg',
      videoUrl: 'https://example.com/video.mp4',
      date: '2024-01-01',
    );
    final List<RecipeModel> recipes = [recipeModel];

    blocTest<RecipesBloc, RecipesState>(
      'emits RecipesLoadedState when GetRecipesEvent is added',
      build: () {
        when(() => mockRecipesDioService.fetchRecipes())
            .thenAnswer((_) async => recipes);
        return recipesBloc;
      },
      act: (bloc) => bloc.add(GetRecipesEvent()),
      expect: () => [
        isA<RecipesLoadingState>(),
        isA<RecipesLoadedState>()
            .having((state) => state.recipes, 'recipes', recipes),
      ],
    );

    blocTest<RecipesBloc, RecipesState>(
      'emits RecipesErrorState when fetchRecipes fails',
      build: () {
        when(() => mockRecipesDioService.fetchRecipes())
            .thenThrow(Exception('Failed to fetch recipes'));
        return recipesBloc;
      },
      act: (bloc) => bloc.add(GetRecipesEvent()),
      expect: () => [
        isA<RecipesLoadingState>(),
        isA<RecipesErrorState>().having(
          (state) => state.error,
          'error',
          'Exception: Failed to fetch recipes',
        ),
      ],
    );
    
  });
}

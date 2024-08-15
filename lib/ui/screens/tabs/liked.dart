import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_state.dart';
import 'package:recipe_app/ui/widgets/saved_recipe_card.dart';

class LikedTab extends StatelessWidget {
  const LikedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserStateLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is UserStateLoaded) {
        final user = state.userModel;
        return BlocBuilder<RecipesBloc, RecipesState>(
          bloc: context.read<RecipesBloc>()..add(GetRecipesEvent()),
          builder: (context, state) {
            if (state is RecipesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipesLoadedState) {
              final recipes = state.recipes;
              final savedRecipes = [];
              for (var element in recipes) {
                if (user.likedReceiptsId.contains(element.id)) {
                  savedRecipes.add(element);
                }
              }

              if (savedRecipes.isEmpty) {
                return const Center(child: Text('No Liked Recipes'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: savedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = savedRecipes[index];
                  return SavedRecipeCard(recipeModel: recipe);
                },
              );
            } else if (state is RecipesErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        );
      } else {
        return Center(
          child: Text("Not Found Saved Resipe"),
        );
      }
    });
  }
}

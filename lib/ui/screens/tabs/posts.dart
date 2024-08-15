import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/ui/widgets/recipe_card.dart';
import 'package:recipe_app/utils/current_user.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesBloc, RecipesState>(
      bloc: context.read<RecipesBloc>()..add(GetRecipesEvent()),
      builder: (context, state) {
        if (state is RecipesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RecipesLoadedState) {
          final recipes = state.recipes;
          final posts = [];
          for (var element in recipes) {
            if (element.creatorId == CurrentUser.currentUser!.localId) {
              posts.add(element);
            }
          }

          if (recipes.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 3 / 4,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return RecipeCard(recipeModel: post);
            },
          );
        } else if (state is RecipesErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: Text('Something went wrong.'));
        }
      },
    );
  }
}

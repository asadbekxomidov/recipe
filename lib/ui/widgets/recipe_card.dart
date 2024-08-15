import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/ui/screens/edit_recipe_screen.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipeModel;

  const RecipeCard({
    super.key,
    required this.recipeModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(10.r),
        image: DecorationImage(
          image: NetworkImage(recipeModel.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeModel.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.h,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Likes: ${recipeModel.likesCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.h,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditRecipeScreen(recipe: recipeModel),
                            ));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 25.h,
                        color: Colors.blue,
                      )),
                  IconButton(
                      onPressed: () {
                        context
                            .read<RecipesBloc>()
                            .add(DeleteRecipeEvent(id: recipeModel.id));
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 25.h,
                        color: Colors.red,
                      )),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

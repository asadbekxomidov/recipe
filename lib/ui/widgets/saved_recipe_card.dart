import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/ui/screens/recipe_detail_screen.dart';

class SavedRecipeCard extends StatelessWidget {
  final RecipeModel recipeModel;

  const SavedRecipeCard({
    super.key,
    required this.recipeModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RecipeDetailsScreen(recipeModel: recipeModel),
            ));
      },
      child: Container(
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
            )
          ],
        ),
      ),
    );
  }
}

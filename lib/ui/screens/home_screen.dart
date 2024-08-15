import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:recipe_app/blocs/user_bloc/user_state.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/ui/screens/management_screen.dart';
import 'package:recipe_app/ui/screens/recipe_detail_screen.dart';
import 'package:recipe_app/utils/current_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RecipeModel> allRecipes = [];
  List<RecipeModel> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    context.read<RecipesBloc>().add(GetRecipesEvent());
    context
        .read<UserBloc>()
        .add(GetUserEvent(CurrentUser.currentUser!.localId));
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      filteredRecipes = allRecipes.where((recipe) {
        final titleLower = recipe.title.toLowerCase();
        final searchLower = _searchController.text.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserStateLoaded) {
            final user = state.userModel;

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User greeting and profile image
                  _buildHeader(user),

                  SizedBox(height: 20.h),

                  // Search bar
                  _buildSearchBar(),

                  SizedBox(height: 10.h),

                  // Recipe sections
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          Text(
                            "New Recipes",
                            style: TextStyle(
                                fontSize: 20.h, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                              height: 280.h,
                              child: _buildRecipeList(user, "new")),
                          Text(
                            "Popular",
                            style: TextStyle(
                                fontSize: 20.h, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                              height: 280.h,
                              child: _buildRecipeList(user, "popular")),
                          Text(
                            "Recent Recipes",
                            style: TextStyle(
                                fontSize: 20.h, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                              height: 280.h,
                              child: _buildRecipeList(user, "recent")),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildHeader(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello ${user.name}",
              style: TextStyle(fontSize: 20.h, fontWeight: FontWeight.w600),
            ),
            Text(
              "What are you cooking today?",
              style: TextStyle(
                  fontSize: 11.h,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffA9A9A9)),
            )
          ],
        ),
        Container(
          width: 40,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.hardEdge,
          child: user.imageUrl.isEmpty
              ? Image.network(
                  "https://verdantfox.com/static/images/avatars_default/av_blank.png",
                  fit: BoxFit.cover,
                )
              : Image.network(
                  user.imageUrl,
                  fit: BoxFit.cover,
                ),
        )
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey, width: 2)),
            height: 55.h,
            child: Row(
              children: [
                const SizedBox(width: 7),
                const Icon(
                  Icons.search,
                  size: 30,
                  color: Color(0xffD9D9D9),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search recipe",
                      hintStyle: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffD9D9D9)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManagementScreen(index: 1),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff129575),
              ),
              height: 55.h,
              child: const Icon(
                Icons.menu,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeList(user, String category) {
    return BlocBuilder<RecipesBloc, RecipesState>(
      builder: (context, state) {
        if (state is RecipesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RecipesLoadedState) {
          allRecipes = state.recipes;
          filteredRecipes =
              _searchController.text.isEmpty ? allRecipes : filteredRecipes;

          List<RecipeModel> displayedRecipes = [];
          if (category == "new") {
            displayedRecipes = filteredRecipes;
          } else if (category == "popular") {
            displayedRecipes = filteredRecipes
              ..sort((a, b) => b.likesCount.compareTo(a.likesCount));
          } else if (category == "recent") {
            DateTime today = DateTime.now();
            DateTime twoDaysAgo = today.subtract(const Duration(days: 2));
            displayedRecipes = filteredRecipes.where((recipe) {
              DateTime recipeDate = DateTime.parse(recipe.date);
              return recipeDate.isAfter(twoDaysAgo) ||
                  recipeDate.isAtSameMomentAs(twoDaysAgo);
            }).toList();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: displayedRecipes.map((recipe) {
                return recipeItem(recipe, user.savedReceiptsId, user.id);
              }).toList(),
            ),
          );
        } else if (state is RecipesErrorState) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: Text('No recipes found.'));
        }
      },
    );
  }

  Widget recipeItem(RecipeModel recipe, List savedRecipes, String userId) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        RecipeDetailsScreen(recipeModel: recipe)));
          },
          child: Container(
            width: 180.w,
            height: 220.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffD9D9D9)),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      recipe.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16.h),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Time",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffA9A9A9),
                              fontSize: 12.h),
                        ),
                        Text(
                          "${recipe.cookingTime} Mins",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12.h),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (savedRecipes.contains(recipe.id)) {
                            savedRecipes.removeWhere(
                              (element) => element == recipe.id,
                            );
                            context.read<UserBloc>().add(AddSavedRecipe(
                                userId: userId, savedRecipe: savedRecipes));
                          } else {
                            savedRecipes.add(recipe.id);
                            context.read<UserBloc>().add(AddSavedRecipe(
                                userId: userId, savedRecipe: savedRecipes));
                          }
                        });
                      },
                      child: Icon(
                        savedRecipes.contains(recipe.id)
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        size: 35.h,
                        color: const Color(0xff129575),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20.w),
      ],
    );
  }
}

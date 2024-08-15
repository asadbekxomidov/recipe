import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/ui/screens/recipe_detail_screen.dart';
import 'package:recipe_app/ui/widgets/search_filter_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';
  String selectedTime = 'All';

  @override
  void initState() {
    super.initState();
    context.read<RecipesBloc>().add(GetRecipesEvent());
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void onTimeSelected(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        centerTitle: true,
        title: const Text('Search Recipes'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  width: 260.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  height: 55.h,
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,
                          size: 30, color: Colors.grey.shade400),
                      hintText: "Search recipe",
                      hintStyle: TextStyle(
                        fontSize: 16.h,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return SearchFilterWidget(
                          onCategorySelected: onCategorySelected,
                          onTimeSelected: onTimeSelected,
                          initialCategory: selectedCategory,
                          initialTime: selectedTime,
                        );
                      },
                    );
                    setState(() {});
                  },
                  child: Container(
                    width: 55.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff129575),
                    ),
                    height: 55.h,
                    child: Center(
                      child: Icon(Icons.menu, size: 30.h, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: BlocBuilder<RecipesBloc, RecipesState>(
                builder: (context, state) {
                  if (state is RecipesLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RecipesLoadedState) {
                    final searchQuery = searchController.text.toLowerCase();

                    final sortedRecipes = state.recipes.toList();

                    if (selectedTime == 'Newest') {
                      sortedRecipes.sort((a, b) => b.date.compareTo(a.date));
                    } else if (selectedTime == 'Oldest') {
                      sortedRecipes.sort((a, b) => a.date.compareTo(b.date));
                    } else if (selectedTime == 'Popularity') {
                      sortedRecipes
                          .sort((a, b) => b.likesCount.compareTo(a.likesCount));
                    }

                    final filteredRecipes = sortedRecipes.where((recipe) {
                      final matchesCategory = selectedCategory == 'All' ||
                          recipe.categoryId == selectedCategory;
                      final matchesSearchQuery =
                          recipe.title.toLowerCase().contains(searchQuery);
                      return matchesCategory && matchesSearchQuery;
                    }).toList();

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15.r,
                        crossAxisSpacing: 15.r,
                        childAspectRatio: 2 / 2,
                      ),
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => RecipeDetailsScreen(
                                        recipeModel: recipe)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(10.r),
                              image: DecorationImage(
                                image: NetworkImage(recipe.imageUrl),
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
                                  recipe.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.h,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Likes: ${recipe.likesCount}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.h,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Text('Date: ${recipe.date}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Error loading recipes'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

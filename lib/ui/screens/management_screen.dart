import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_bloc.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_state.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/ui/screens/add_recipe_screen.dart';
import 'package:recipe_app/ui/screens/home_screen.dart';
import 'package:recipe_app/ui/screens/profile_screen.dart';
import 'package:recipe_app/ui/screens/reels_screen.dart';
import 'package:recipe_app/ui/screens/search_screen.dart';

class ManagementScreen extends StatefulWidget {
  final int index;
  const ManagementScreen({super.key, required this.index});

  @override
  State<StatefulWidget> createState() {
    return _ManagementScreenState();
  }
}

class _ManagementScreenState extends State<ManagementScreen> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomeScreen(),
          SearchScreen(),
          AddRecipeScreen(),
          ReelsScreen(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20.h,
        unselectedFontSize: 18.h,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<AddRecipeBloc, AddRecipeState>(
              builder: (context, state) {
                if (state is RecipeUploadingState) {
                  return const CircularProgressIndicator();
                } else {
                  context.read<RecipesBloc>().add(GetRecipesEvent());
                  return const Icon(Icons.add_circle);
                }
              },
            ),
            label: 'Add',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_rounded),
            label: 'Reels',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

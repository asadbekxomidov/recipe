// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final RecipeModel recipeModel;

  RecipeDetailsScreen({required this.recipeModel});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.recipeModel.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            _controller.seekTo(Duration.zero);
            _controller.play();
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      _showFullScreenDialog();
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _showFullScreenDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Positioned(
                top: 20.h,
                right: 20.w,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.amber.shade900,
                    size: 30.h,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isFullScreen = false;
                    });
                    SystemChrome.setEnabledSystemUIMode(
                        SystemUiMode.edgeToEdge);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.recipeModel.title),
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(200, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(
                          Icons.share,
                          color: Colors.black,
                          size: 24.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Share',
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'unsave',
                    child: Row(
                      children: [
                        Icon(
                          Icons.bookmark_remove,
                          color: Colors.black,
                          size: 24.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Unsave',
                          style: TextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).then((value) {
                if (value == 'share') {
                  _shareRecipe(widget.recipeModel);
                } else if (value == 'unsave') {}
              });
            },
            icon: Icon(
              Icons.more_horiz,
              size: 25.h,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          if (state is RecipesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipesLoadedState) {
            final recipe = state.recipes.firstWhere(
              (r) => r.id == widget.recipeModel.id,
              orElse: () => widget.recipeModel,
            );
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _controller.value.isInitialized
                        ? Stack(
                            children: [
                              Container(
                                height: 220.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width: _controller.value.size.width,
                                    height: _controller.value.size.height,
                                    child: VideoPlayer(_controller),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10.h,
                                right: 10.w,
                                child: IconButton(
                                  icon: Icon(
                                    _isFullScreen
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    color: Colors.white,
                                    size: 25.h,
                                  ),
                                  onPressed: _toggleFullscreen,
                                ),
                              ),
                              Positioned(
                                bottom: 20.h,
                                right: 50.w,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      size: 20.h,
                                      color: Colors.amber.shade900,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      '${recipe.cookingTime.toString()} min',
                                      style: TextStyle(
                                        fontSize: 12.h,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10.h,
                                left: 10.w,
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 25.h,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _controller.value.isPlaying
                                          ? _controller.pause()
                                          : _controller.play();
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: 200.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                    SizedBox(height: 20.h),
                    Text(
                      recipe.stagesOfPreparation,
                      style: TextStyle(
                        fontSize: 24.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Category: ${recipe.categoryId}',
                      style: TextStyle(
                        fontSize: 16.h,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Likes: ${recipe.likesCount}',
                      style: TextStyle(
                        fontSize: 16.h,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      recipe.ingredients,
                      style: TextStyle(
                        fontSize: 18.h,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            );
          } else if (state is RecipesErrorState) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else {
            return const Center(
              child: Text('No details available'),
            );
          }
        },
      ),
    );
  }

  void _shareRecipe(RecipeModel recipe) {
    final String shareText = '''
Check out this recipe:
Title: ${recipe.title}
Ingredients: ${recipe.ingredients}
Preparation: ${recipe.stagesOfPreparation}
Cooking Time: ${recipe.cookingTime} minutes
Category: ${recipe.categoryId}
Likes: ${recipe.likesCount}
Watch the video: ${recipe.videoUrl}
''';
    Share.share(shareText, subject: 'Check out this recipe!');
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_bloc.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_event.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_state.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stagesController = TextEditingController();
  String? selectedCategory;
  int cookingTime = 0;
  File? imageFile;
  File? videoFile;

  final List<String> _categories = [
    "Nonushta",
    "Tushlik",
    "Kechki ovqat",
    "Shirinlik",
    "Salat"
  ];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.recipe.title;
    ingredientsController.text = widget.recipe.ingredients;
    stagesController.text = widget.recipe.stagesOfPreparation;
    selectedCategory = widget.recipe.categoryId;
    cookingTime = widget.recipe.cookingTime;
    setState(() {});
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        videoFile = File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SizedBox(
            height: 700,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 400,
                    child: TextFormField(
                      controller: ingredientsController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        labelText: 'Ingredients',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ingredients';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 300,
                    child: TextFormField(
                      controller: stagesController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        labelText: 'Stages of Preparation',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter stages of preparation';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    items: _categories
                        .map<DropdownMenuItem<String>>((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cooking Time: $cookingTime min'),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => setState(() {
                              if (cookingTime > 0) cookingTime -= 1;

                            }),
                            child: const Icon(Icons.remove),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => setState(() {
                              cookingTime += 1;
                            }),
                            child: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Add Image'),
                  ),
                  if (imageFile != null) ...[
                    const SizedBox(height: 8.0),
                    Image.file(imageFile!, height: 100, width: 100),
                  ],
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.video_library),
                    label: const Text('Add Video'),
                  ),
                  if (videoFile != null) ...[
                    const SizedBox(height: 8.0),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          videoFile!.path.split("/").last,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32.0),
                  BlocBuilder<AddRecipeBloc, AddRecipeState>(
                      builder: (context, state) {
                    if (state is RecipeUploadingState) {
                      return Container(
                        height: 20,
                        width: 50,
                        padding: const EdgeInsets.all(10),
                        child: const CircularProgressIndicator(),
                      );
                    }
                    return ElevatedButton(
                      onPressed: state is RecipeUploadingState
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                context.read<AddRecipeBloc>().add(EditRecipe(
                                    id: widget.recipe.id,
                                    creatorId: widget.recipe.creatorId,
                                    title: titleController.text,
                                    ingredients: ingredientsController.text,
                                    stagesOfPreparation: stagesController.text,
                                    categoryId: selectedCategory!,
                                    cookingTime: cookingTime,
                                    imageUrl: widget.recipe.imageUrl,
                                    videoUrl: widget.recipe.videoUrl,
                                    imageFile: imageFile,
                                    videoFile: videoFile));
                              }
                              context
                                  .read<RecipesBloc>()
                                  .add(GetRecipesEvent());
                              Navigator.pop(context);
                            },
                      child: state is RecipeUploadingState
                          ? const CircularProgressIndicator()
                          : const Text('Submit Recipe'),

                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

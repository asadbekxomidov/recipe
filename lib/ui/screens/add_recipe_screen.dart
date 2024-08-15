import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_bloc.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_event.dart';
import 'package:recipe_app/blocs/add_recipe_bloc/add_recipe_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/ui/screens/management_screen.dart';
import 'package:recipe_app/utils/current_user.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
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
        leading: const SizedBox(),
        title: const Text('Create Recipe'),
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
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      height: 50.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          'Add Image',
                          style: TextStyle(
                            fontSize: 16.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (imageFile != null) ...[
                    const SizedBox(height: 8.0),
                    Image.file(imageFile!, height: 140.h, width: 140.w),
                  ],
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: _pickVideo,
                    child: Container(
                      height: 50.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          'Add Video',
                          style: TextStyle(
                            fontSize: 16.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
                    return InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              context.read<AddRecipeBloc>().add(
                                    AddRecipe(
                                        creatorId:
                                            CurrentUser.currentUser!.localId!,
                                        title: titleController.text,
                                        ingredients: ingredientsController.text,
                                        stagesOfPreparation:
                                            stagesController.text,
                                        category: selectedCategory!,
                                        cookingTime: cookingTime,
                                        imageFile: imageFile,
                                        videoFile: videoFile),
                                  );
                              return const ManagementScreen(index: 0);
                            },
                          ));
                        }
                      },
                      child: Container(
                        height: 50.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Text(
                            'Submit Recipe',
                            style: TextStyle(
                              fontSize: 16.h,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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

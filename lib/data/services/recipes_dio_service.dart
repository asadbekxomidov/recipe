import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class RecipesDioService {
  Dio dio = Dio();

  Future<List<RecipeModel>> fetchRecipes() async {
    try {
      final response = await dio.get(
          "https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes.json");

      final List<RecipeModel> loadedRecipes = [];

      response.data.forEach((key, value) {
        value['id'] = key;
        loadedRecipes.add(RecipeModel.fromJson(value));
      });

      return loadedRecipes;
    } on DioException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<RecipeModel>> getRecipesByUserId(String userId) async {
    try {
      final response = await dio.get(
          'https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes.json?orderBy="creatorId"&equalTo="$userId"');
      List<RecipeModel> recipes = [];
      response.data.forEach(
        (key, value) {
          value['id'] = key;
          recipes.add(
            RecipeModel.fromJson(value),
          );
        },
      );
      return recipes;
    } on DioException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addRecipe(
    String creatorId,
    String title,
    String ingredients,
    String stagesOfPreparation,
    String category,
    int cookingTime,
    File? imageFile,
    File? videoFile,
  ) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _uploadFiles,
      [
        receivePort.sendPort,
        {
          "creatorId": creatorId,
          "title": title,
          "ingredients": ingredients,
          "stagesOfPreparation": stagesOfPreparation,
          "category": category,
          "cookingTime": cookingTime,
          "imageFile": imageFile,
          "videoFile": videoFile,
          "operationType": "add",
        },
      ],
    );

    await for (final message in receivePort) {
      if (message is String && message == 'done') {
        receivePort.close();
        break;
      } else if (message is String) {}
    }
  }

  Future<void> changeLike(String id, bool isIncrease) async {
    try {
      final response = await dio.get(
          "https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes/$id.json");
      if (isIncrease) {
        response.data['likesCount'] += 1;
      } else {
        response.data['likesCount'] -= 1;
      }
      await dio.patch(
          "https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes/$id.json",
          data: response.data);
    } on DioException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editRecipe(
    String id,
    String title,
    String ingredients,
    String stagesOfPreparation,
    String categoryId,
    int cookingTime,
    String imageUrl,
    String videoUrl,
    File? imageFile,
    File? videoFile,
  ) async {
    if (imageFile == null || videoFile == null) {
      final receivePort = ReceivePort();

      await Isolate.spawn(_uploadFiles, [
        receivePort.sendPort,
        {
          'id': id,
          'title': title,
          'ingredients': ingredients,
          "stagesOfPreparation": stagesOfPreparation,
          "categoryId": categoryId,
          "cookingTime": cookingTime,
          "imageUrl": imageUrl,
          "videoUrl": videoUrl,
          "imageFile": imageFile,
          "videoFile": videoFile,
          'operationType': "edit"
        }
      ]);

      await for (var message in receivePort) {
        if (message is Map<String, dynamic> && message['status'] == "done") {
          await patchRecipe(
              id,
              title,
              ingredients,
              stagesOfPreparation,
              categoryId,
              cookingTime,
              message['imageUrl'],
              message['videoUrl']);
        }
      }
    } else {
      patchRecipe(id, title, ingredients, stagesOfPreparation, categoryId,
          cookingTime, imageUrl, videoUrl);
    }
  }

  Future<void> patchRecipe(
    String id,
    String title,
    String ingredients,
    String stagesOfPreparation,
    String categoryId,
    int cookingTime,
    String imageUrl,
    String videoUrl,
  ) async {
    dio.patch(
        "https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes/$id.json",
        data: {
          'title': title,
          'ingredients': ingredients,
          "stagesOfPreparation": stagesOfPreparation,
          "categoryId": categoryId,
          "cookingTime": cookingTime,
          "imageUrl": imageUrl,
          "videoUrl": videoUrl,
        });
  }

  Future<void> deleteRecipe(String id) async {
    try {
      Dio dio = Dio();

      await dio.delete(
          "https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes/$id.json");
    } on DioException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> _uploadFile(Dio dio, File file, String fileType) async {
    final fileName = basename(file.path);
    final String firebaseStorageUrl =
        'https://firebasestorage.googleapis.com/v0/b/recipe-app-6e080.appspot.com/o?name=$fileName';

    FormData formData = FormData.fromMap({
      fileType: await MultipartFile.fromFile(file.path, filename: fileName),
    });

    Response response = await dio
        .post(firebaseStorageUrl, data: formData)
        .whenComplete(() => null);
    String name = response.data['contentDisposition'].split("'").last;
    String token = response.data['downloadTokens'];

    if (response.statusCode == 200) {
      return "https://firebasestorage.googleapis.com/v0/b/recipe-app-6e080.appspot.com/o/$name?alt=media&token=$token";
    } else {
      throw Exception('Failed to upload $fileType');
    }
  }

  Future<void> _uploadFiles(List<dynamic> args) async {
    final sendPort = args[0] as SendPort;
    final params = args[1] as Map<String, dynamic>;

    try {
      Dio dio = Dio();

      String videoUrl = params['videoFile'] == null
          ? params['videoUrl']
          : await _uploadFile(dio, params['videoFile'], "video");
      String imageUrl = params['imageFile'] == null
          ? params['imageUrl']
          : await _uploadFile(dio, params['imageFile'], "image");

      if (params['operationType'] == "add") {
        await _submitRecipe(dio, params, imageUrl, videoUrl);
      } else if (params['operationType'] == 'edit') {
        sendPort.send(
            {'imageUrl': imageUrl, 'videoUrl': videoUrl, 'status': 'done'});
      }

      sendPort.send('Recipe put successfully!');
      sendPort.send('done');
    } catch (e) {
      sendPort.send('Failed to put recipe: $e');
      sendPort.send('done');
    }
  }

  Future<void> _submitRecipe(Dio dio, Map<String, dynamic> params,
      String imageUrl, String videoUrl) async {
    Map<String, dynamic> data = {
      'creatorId': params['creatorId'],
      'title': params['title'],
      'ingredients': params['ingredients'],
      'stagesOfPreparation': params['stagesOfPreparation'],
      'categoryId': params['category'],
      'cookingTime': params['cookingTime'],
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'likesCount': 0,
      'date': DateTime.now().toString(),
    };

    Response response = await dio.post(
        "https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes.json",
        data: data);

    if (response.statusCode != 200) {
      throw Exception('Failed to submit recipe');
    }
  }

  Future<void> addComment(
      String recipeId, String commentatorId, String text) async {
    final response = await dio.get(
        "https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes/$recipeId.json");
    response.data['comments'].add(
      {
        "commentatorId": commentatorId,
        "text": text,
      },
    );
    await dio.patch(
      "https://recipe-app-6e080-default-rtdb.firebaseio.com/recipes/$recipeId.json",
      data: response.data,
    );
  }
}

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:user_repository/src/models/user_model.dart';

class UserService {
  late final Dio _dio;
  String baseUrl = "https://recipe-app-6e080-default-rtdb.firebaseio.com/";
  final _imageStorage = FirebaseStorage.instance;

  UserService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
  }

  // get user
  Future<Map<String, dynamic>?> getUser(String? userId) async {
    String url = "users/$userId.json";
    try {
      final response = await _dio.get(url);
      print("User data: ${response.data}");
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      print("S: User get User Error $e");
      rethrow;
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get(
          "https://recipe-app-6e080-default-rtdb.firebaseio.com/users.json");

      final List<UserModel> loadedUsers = [];

      response.data.forEach((key, value) {
        print(value);
        value['id'] = key;
        loadedUsers.add(UserModel.fromJson(value));
      });

      return loadedUsers;
    } on DioException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }


  Future<void> addSavedRecipe(String userId, List updatedData) async {
    Dio dio = Dio();

    String url = 'https://recipe-app-6e080-default-rtdb.firebaseio.com/users/$userId.json';

     try {
      final response = await dio.patch(url, data: {
        "savedReceiptsId":updatedData
      });

      if (response.statusCode == 200) {
        print("Data updated successfully!");
      } else {
        print("Failed to update data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating data: $e");
    }
  }
  Future<void> addLikedRecipe(String userId, List updatedData) async {
    Dio dio = Dio();

    String url = 'https://recipe-app-6e080-default-rtdb.firebaseio.com/users/$userId.json';

     try {
      final response = await dio.patch(url, data: {
        "likedReceiptsId":updatedData
      });

      if (response.statusCode == 200) {
        print("Data updated successfully!");
      } else {
        print("Failed to update data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  // editName
  Future<void> editName(String newName, String? userId) async {
    String url = "users/$userId.json";
    try {
      final response = await _dio.patch(url, data: {"name": newName});
      print("Name updated: ${response.data}");
    } catch (e) {
      print("S: User edit Name Error $e");
      rethrow;
    }
  }

  // editBio
  Future<void> editBio(String newBio, String? userId) async {
    String url = "users/$userId.json";
    try {
      final response = await _dio.patch(url, data: {"bio": newBio});
      print("Bio updated: ${response.data}");
    } catch (e) {
      print("S: User edit Bio Error $e");
      rethrow;
    }
  }

  // editPhoto
  Future<void> editPhoto(File image, String userId) async {
    try {
      final imageReference = _imageStorage
          .ref()
          .child("users")
          .child("images")
          .child("$userId.jpg");

      final uploadTask = imageReference.putFile(image);

      uploadTask.snapshotEvents.listen((event) {
        print(event.state);

        double percentage = (event.bytesTransferred / image.lengthSync()) * 100;

        print("$percentage%");
      });

      await uploadTask;

      final imageUrl = await imageReference.getDownloadURL();
      String url = "users/$userId.json";

      try {
        final response = await _dio.patch(url, data: {"imageUrl": imageUrl});
        print("Photo URL updated: ${response.data}");
      } catch (e) {
        print("S: User edit imageUrl Error $e");
        rethrow;
      }
    } catch (e) {
      print("S: Rasm yuklashda xatolik: $e");
      rethrow;
    }
  }
}

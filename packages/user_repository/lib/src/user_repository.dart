// ignore_for_file: avoid_print

import 'dart:io';

import 'package:user_repository/src/models/user_model.dart';
import 'package:user_repository/src/services/user_service.dart';

class UserRepository {
  final UserService _userService;

  UserRepository({UserService? userService})
      : _userService = userService ?? UserService();

  Future<UserModel?> getUserById(String? userId) async {
    try {
      final userData = await _userService.getUser(userId);
      if (userData != null) {
        userData["id"] = userId;
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      print("UserRepository getUserById error: $e");
      rethrow;
    }
  }

  Future<void> addSavedRecipe(String userId, List updatedData) async {
    try {
      await _userService.addSavedRecipe(userId, updatedData);
    } catch (e) {
      print("UserRepository updateUserName error: $e");
      rethrow;
    }
  }
  Future<void> addLikedRecipe(String userId, List updatedData) async {
    try {
      await _userService.addLikedRecipe(userId, updatedData);
    } catch (e) {
      print("UserRepository updateUserName error: $e");
      rethrow;
    }
  }

  Future<void> updateUserName(String? userId, String newName) async {
    try {
      await _userService.editName(newName, userId);
    } catch (e) {
      print("UserRepository updateUserName error: $e");
      rethrow;
    }
  }

  Future<void> updateUserBio(String? userId, String newBio) async {
    try {
      await _userService.editBio(newBio, userId);
    } catch (e) {
      print("UserRepository updateUserBio error: $e");
      rethrow;
    }
  }

  Future<void> updateUserPhoto(String userId, File image) async {
    try {
      await _userService.editPhoto(image, userId);
    } catch (e) {
      print("UserRepository updateUserPhoto error: $e");
      rethrow;
    }
  }
}

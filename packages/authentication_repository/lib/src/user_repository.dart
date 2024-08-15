import 'dart:async';

import 'package:authentication_repository/src/local_db/local_db.dart';
import 'package:authentication_repository/src/service/user_service.dart';

import 'models/user_auth.dart';

class UserAuthRepository {
  final UserService _userService = UserService();

  Future<UserAuth?> getUser() async {
    final response = await _userService.getUserInfo();
    if (response != null) {
      return UserAuth.fromList(response["users"], await LocalDb.getIdToken());
    }
    return null;
  }
}

import 'dart:async';

import 'package:authentication_repository/src/local_db/local_db.dart';
import 'package:authentication_repository/src/models/user_auth.dart';
import 'package:authentication_repository/src/service/authentication_service.dart';
import 'package:authentication_repository/src/service/user_service.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final AuthenticationService _authService = AuthenticationService();
  final UserService _userService = UserService();

  Stream<AuthenticationStatus> get status async* {
    final bool isLoggedIn = await LocalDb.checkIfLoggedIn();
    yield isLoggedIn
        ? AuthenticationStatus.authenticated
        : AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<UserAuth> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.singIn(email, password);
      final idToken = response['idToken'];
      await LocalDb.saveToken(idToken);

      _controller.add(AuthenticationStatus.authenticated);
      return UserAuth.fromJson(response);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      rethrow;
    }
  }

  Future<UserAuth> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.singUp(email, password);
      final idToken = response['idToken'];
      await LocalDb.saveToken(idToken);
      await _userService.createUser(
        uid: response["localId"],
        idToken: idToken,
        userData: {
          "name": name,
          "email": email,
        },
      );

      _controller.add(AuthenticationStatus.authenticated);
      return UserAuth.fromJson(response);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      rethrow;
    }
  }

  Future<void> logOut() async {
    await LocalDb.deleteToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}

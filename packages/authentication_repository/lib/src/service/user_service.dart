// ignore_for_file: avoid_print

import 'package:authentication_repository/src/local_db/local_db.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio();
  final String _apiKey = "AIzaSyBz_kxTn6hVhxT7g4q6RT-PYKQdCJKL7v8";

  Future<void> createUser({
    required String uid,
    required String idToken,
    required Map<String, dynamic> userData,
  }) async {
    final url =
        'https://recipe-app-6e080-default-rtdb.firebaseio.com/users/$uid.json?auth=$idToken';

    try {
      final response = await _dio.put(url, data: userData);
      print("Create user response: $response");
    } catch (e) {
      print("CreateUser xatosi: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$_apiKey";

    try {
      final token = await LocalDb.getIdToken();
      if (token != null) {
        final response = await _dio.post(
          url,
          data: {
            'idToken': token,
          },
        );
        print("Bu auth pakcagedagi getUserInfo response: $response");
        return response.data;
      }
      return null;
    } catch (e) {
      print("GetUserInfo da Xatolik: $e");
      rethrow;
    }
  }
}

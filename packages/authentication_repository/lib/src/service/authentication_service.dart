// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class AuthenticationService {
  late final Dio _dio;
  final String _apiKey = "AIzaSyBz_kxTn6hVhxT7g4q6RT-PYKQdCJKL7v8";


  AuthenticationService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://identitytoolkit.googleapis.com/v1/accounts",
      ),
    );
  }

  Future<Map<String, dynamic>> singUp(String email, String password) async {
    final url = ":signUp?key=$_apiKey";
    try {
      final response = await _dio.post(
        url,
        data: {
          "email": email,
          "password": password,
          "returnSercureToken": true,
        },
      );


      print("Bu auth packagedagi singUp response: $response");
      return response.data;
    } on Exception catch (e) {
      print("Sing Upda Xatolik: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> singIn(String email, String password) async {
    final url = ":signInWithPassword?key=$_apiKey";

    try {
      final response = await _dio.post(
        url,
        data: {
          "email": email,
          "password": password,
          "returnSercureToken": true,
        },
      );

      print("Bu auth pakcagedagi singIn response: $response");
      return response.data;
    } catch (e) {
      print("Sing Upda Xatolik: $e");
      rethrow;
    }
  }
}

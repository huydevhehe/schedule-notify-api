import 'package:dio/dio.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<({String access, String refresh})> login(String username, String password) async {
    final response = await _dio.post('/api/auth/login/', data: {
      'username': username,
      'password': password,
    });
    return (access: response.data['access'] as String, refresh: response.data['refresh'] as String);
  }

  Future<Map<String, dynamic>> fetchMe() async {
    final response = await _dio.get('/api/me/');
    return response.data as Map<String, dynamic>;
  }
}

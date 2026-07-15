import 'package:app/features/auth/data/auth_api.dart';
import 'package:app/features/auth/domain/token_storage.dart';
import 'package:app/features/auth/domain/user.dart';

class AuthRepository {
  AuthRepository({required AuthApi api, required TokenStorage tokenStorage})
      : _api = api,
        _tokenStorage = tokenStorage;

  final AuthApi _api;
  final TokenStorage _tokenStorage;

  Future<User> login(String username, String password) async {
    final tokens = await _api.login(username, password);
    await _tokenStorage.saveTokens(accessToken: tokens.access, refreshToken: tokens.refresh);
    final meJson = await _api.fetchMe();
    return User.fromJson(meJson);
  }

  Future<User?> tryRestoreSession() async {
    final token = await _tokenStorage.readAccessToken();
    if (token == null) return null;
    final meJson = await _api.fetchMe();
    return User.fromJson(meJson);
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/data/auth_api.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/data/secure_token_storage.dart';
import 'package:app/features/auth/domain/token_storage.dart';
import 'package:app/features/auth/domain/user.dart';
import 'package:app/core/network/api_client.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => SecureTokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(tokenStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(
    api: AuthApi(apiClient.dio),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

class AuthController extends AsyncNotifier<User?> {
  @override
  Future<User?> build() {
    return ref.read(authRepositoryProvider).tryRestoreSession();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).login(username, password),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(AuthController.new);

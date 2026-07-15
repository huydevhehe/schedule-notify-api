import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/features/auth/data/auth_api.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/domain/token_storage.dart';

class _MockAuthApi extends Mock implements AuthApi {}

class _FakeTokenStorage implements TokenStorage {
  String? access;
  String? refresh;

  @override
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    access = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
  }
}

void main() {
  late _MockAuthApi api;
  late _FakeTokenStorage tokenStorage;
  late AuthRepository repository;

  setUp(() {
    api = _MockAuthApi();
    tokenStorage = _FakeTokenStorage();
    repository = AuthRepository(api: api, tokenStorage: tokenStorage);
  });

  test('login saves tokens and returns the current user', () async {
    when(() => api.login('thao', 'pass1234'))
        .thenAnswer((_) async => (access: 'access-tok', refresh: 'refresh-tok'));
    when(() => api.fetchMe()).thenAnswer((_) async => {
          'id': 1,
          'username': 'thao',
          'role': 'admin',
          'units': [
            {'id': 1, 'name': 'VTTP', 'code': 'VTTP'}
          ],
        });

    final user = await repository.login('thao', 'pass1234');

    expect(user.username, 'thao');
    expect(tokenStorage.access, 'access-tok');
    expect(tokenStorage.refresh, 'refresh-tok');
  });

  test('tryRestoreSession returns null when no token is stored', () async {
    final user = await repository.tryRestoreSession();
    expect(user, isNull);
  });

  test('tryRestoreSession returns the user when a token is stored', () async {
    await tokenStorage.saveTokens(accessToken: 'access-tok', refreshToken: 'refresh-tok');
    when(() => api.fetchMe()).thenAnswer((_) async => {
          'id': 1,
          'username': 'thao',
          'role': 'employee',
          'units': <Map<String, dynamic>>[],
        });

    final user = await repository.tryRestoreSession();

    expect(user, isNotNull);
    expect(user!.role, isNotNull);
  });

  test('logout clears stored tokens', () async {
    await tokenStorage.saveTokens(accessToken: 'a', refreshToken: 'b');
    await repository.logout();
    expect(tokenStorage.access, isNull);
  });
}

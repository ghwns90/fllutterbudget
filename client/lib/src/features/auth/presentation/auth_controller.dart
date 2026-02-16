import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../data/token_storage.dart';

part 'auth_controller.g.dart';

// 로그인 상태(Enum)
enum AuthStatus { initial, authenticated, unauthenticated }

@Riverpod(keepAlive: true) // 앱이 꺼질 때 까지 유지
class AuthController extends _$AuthController {
  @override
  Future<AuthStatus> build() async {
    // 앱 시작 시 토큰 있는지 확인
    final token = await ref.read(tokenStorageProvider).getRefreshToken();
    if (token != null) {
      return AuthStatus.authenticated;
    }

    return AuthStatus.unauthenticated;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final tokens = await repo.login(email, password);

      await ref
          .read(tokenStorageProvider)
          .saveTokens(
            accessToken: tokens['accessToken'],
            refreshToken: tokens['refreshToken'],
          );

      state = const AsyncValue.data(AuthStatus.authenticated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow; // UI에서 에러 처리할 수 있게
    }
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clearTokens();
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }
}

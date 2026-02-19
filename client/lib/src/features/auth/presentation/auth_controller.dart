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
    // state = const AsyncValue.loading(); // 로딩 상태 제거 (UI에서 로컬 관리)
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
    } catch (e) {
      // 에러 발생 시 상태를 'Unauthenticated'로 원복해야 라우터가 튕기지 않음
      state = const AsyncValue.data(AuthStatus.unauthenticated);
      rethrow; // UI에서 에러 처리할 수 있게
    }
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clearTokens();
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }
}

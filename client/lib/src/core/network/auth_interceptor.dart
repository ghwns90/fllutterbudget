import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/token_storage.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/auth_controller.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;
  AuthInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 헤더에 토큰 추가
    try {
      final token = await ref.read(tokenStorageProvider).getAccessToken();
      print('🔑 [Interceptor] Token injected: ${token != null ? "YES" : "NO"}');

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {}
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //401 에러(토큰만료) 발생 시
    if (err.response?.statusCode == 401) {
      // 이미 리프레시 요청이었다면(무한루프 방지)
      if (err.requestOptions.path.contains('/refresh')) {
        return handler.next(err);
      }

      // 로그인/회원가입 실패(401)는 토큰 만료가 아니라 비번 틀린거임 -> 인터셉트 X
      if (err.requestOptions.path.contains('/login') || 
          err.requestOptions.path.contains('/signup')) {
        return handler.next(err);
      }

      final refreshToken = await ref
          .read(tokenStorageProvider)
          .getRefreshToken();

      // 리프레시 토큰 없으면 에러 처리(로그아웃)
      if (refreshToken == null) {
        return handler.next(err);
      }

      try {
        // 토큰 재발급 요청
        final repo = ref.read(authRepositoryProvider);
        final newTokens = await repo.refresh(refreshToken);

        // 새 토큰 저장
        await ref
            .read(tokenStorageProvider)
            .saveTokens(
              accessToken: newTokens['accessToken'],
              refreshToken: newTokens['refreshToken'],
            );

        // 원래 요청 재시도 (헤더 교체)
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${newTokens['accessToken']}';

        // dio 인스턴스를 새로 만들어서 재요청 (기존 인터셉터 영향 안 받게)
        final clonedRequest = await Dio().fetch(opts);
        return handler.resolve(clonedRequest);
      } catch (e) {
        // 재발급 실패 -> 로그아웃
        ref.read(authControllerProvider.notifier).logout();
        return handler.next(err);
      }
    }

    handler.next(err);
  }
}

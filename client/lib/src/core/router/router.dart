import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/transactions/presentation/transaction_list_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  // 인증 상태를 구독 (변경될때마다 라우터가 반응)
  final authStatus = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    // 디버그용 로그
    debugLogDiagnostics: true,
    // 리다이렉트 로직
    redirect: (context, state) {
      // 로딩중이면 아무것도 안함
      if(authStatus is AsyncLoading) return null;

      final isAuthenticated = authStatus.value == AuthStatus.authenticated;
      final isLoginRequest = state.uri.path == '/login';
      final isSignupRequest = state.uri.path == '/signup';

      if(!isAuthenticated) {
        // 로그인 X -> 로그인 페이지로
        return isSignupRequest ? null : '/login';
      }

      if(isAuthenticated && (isLoginRequest || isSignupRequest)) {
        // 이미 로그인 했는데 로그인/회원가입 페이지로 가려고 하면 -> 홈으로
        return '/';
      }

      return null; // 원래 가려던 곳으로 허용
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const TransactionListScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
  );
}
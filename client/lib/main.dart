import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // import 추가
import 'package:intl/date_symbol_data_local.dart';
import 'src/features/transactions/presentation/transaction_list_screen.dart';
import 'src/core/router/router.dart';

void main() async {
  // 날짜 포맷팅 초기화 (한국어 'ko')
  await initializeDateFormatting('ko', null);
  runApp(const ProviderScope(child: MyApp())); // ProviderScope 필수
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Budget App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      // 한국어 지원 설정
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
    );
  }
}

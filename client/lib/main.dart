import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/features/transactions/presentation/transaction_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); // ProviderScope 필수
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const TransactionListScreen(),
    );
  }
}
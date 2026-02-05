import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_list_provider.dart';
import 'add_transaction_screen.dart'; 

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider 구독 (데이터 변하면 화면 자동 갱신)
    final asyncTransactions = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('가계부 💸')),
      body: asyncTransactions.when(
        // 데이터 로딩 중일 때
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // 에러 났을 때
        error: (err, stack) => Center(child: Text('에러 발생: $err')),
        
        // 데이터 도착했을 때 (transactions가 그 데이터임)
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('거래 내역이 없습니다.'));
          }

          return ListView.separated(
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = transactions[index];
              final isExpense = item.type == 'EXPENSE';

              return ListTile(
                leading: Text(item.categoryIcon, style: const TextStyle(fontSize: 24)),
                title: Text(item.title),
                subtitle: Text(item.transactionAt),
                trailing: Text(
                  '${isExpense ? '-' : '+'}${item.amount}원',
                  style: TextStyle(
                    color: isExpense ? Colors.red : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 글쓰기 화면으로 이동
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
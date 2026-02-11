import 'package:client/src/features/transactions/data/transaction_repository.dart';
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
      appBar: AppBar(title: const Text('가계부')),
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
              print(
                '🎨 [UI] Building item $index: ${item.title}, ${item.amount}, ${item.categoryIcon}',
              ); // UI 데이터 확인
              final isExpense = item.type == 'EXPENSE';

              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  // [Optimistic Update] Notifier에게 삭제 위임 (화면에서 즉시 삭제됨)
                  ref
                      .read(transactionListProvider.notifier)
                      .deleteTransaction(item.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('삭제되었습니다'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                // 밀기 전에 진짜 지울건지 물어보기 (옵션)
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text(
                            '삭제',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isExpense
                            ? Colors.red[50]
                            : Colors.blue[50], // 생동감 있는 배경
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        item.categoryIcon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${item.transactionAt.substring(0, 10)} ${item.memo ?? ''}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Text(
                      '${isExpense ? '-' : '+'}${item.amount}원',
                      style: TextStyle(
                        color: isExpense ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddTransactionScreen(initialTransaction: item),
                        ),
                      );
                    },
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
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

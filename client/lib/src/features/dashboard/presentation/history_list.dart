import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/dashboard_repository.dart';
import '../../transactions/domain/transaction_model.dart';

// 리스트 데이터 Provider
final historyProvider = 
  FutureProvider.family.autoDispose<List<TransactionModel>,
  ({String yearMonth, String type})>((ref, arg) async {
    return ref.watch(dashboardRepositoryProvider).getHistory(arg.yearMonth, arg.type);
  });

  class HistoryList extends ConsumerWidget {
    final String yearMonth;
    final String type;

    const HistoryList({required this.yearMonth, required this.type, super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {

      // Record 타입 키 사용 ((yearMonth: ..., type: ...))  
      final historyAsync = ref.watch(historyProvider((yearMonth: yearMonth, type: type)));

      return historyAsync.when(
        data: (transactions) {
          if(transactions.isEmpty) {
            return const Center(child: Text('내역이 없습니다'));
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return ListTile(
                leading: Icon(
                  type == 'INCOME' ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                  color: type == 'INCOME' ? Colors.blue : Colors.red,
                ),
                title: Text(tx.title),
                subtitle: Text(DateFormat('MM.dd HH:mm').format(DateTime.parse(tx.transactionAt))),
                trailing: Text(
                  '${NumberFormat("#,###").format(tx.amount)}원',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      );
    }
  }
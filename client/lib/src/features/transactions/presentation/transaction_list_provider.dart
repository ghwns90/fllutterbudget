import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction_model.dart';

part 'transaction_list_provider.g.dart';

@riverpod
Future<List<TransactionModel>> transactionList(TransactionListRef ref) async {
  // Repository한테 데이터 달라고 시킴
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactions();
}

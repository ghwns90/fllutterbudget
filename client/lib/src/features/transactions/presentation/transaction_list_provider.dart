import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction_model.dart';

part 'transaction_list_provider.g.dart';

@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<TransactionModel>> build() async {
    final repository = ref.watch(transactionRepositoryProvider);
    return repository.getTransactions();
  }

  // 데이터 추가 후 리스트 갱신 (Invalidate)
  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(transactionRepositoryProvider);
      return repository.getTransactions();
    });
  }

  // [Optimistic Update] 삭제 기능 - 화면에서 먼저 지우고 서버 요청
  Future<void> deleteTransaction(int id) async {
    final previousState = state.value;
    if (previousState == null) return;

    // 1. 화면에서 먼저 지움 (사용자 경험 UP!)
    state = AsyncValue.data(previousState.where((t) => t.id != id).toList());

    try {
      // 2. 서버에 삭제 요청
      final repository = ref.read(transactionRepositoryProvider);
      await repository.deleteTransaction(id);
    } catch (e) {
      // 3. 실패하면 롤백 (원래 데이터로 복구)
      state = AsyncValue.data(previousState);
      throw Exception('삭제 실패: $e');
    }
  }
}

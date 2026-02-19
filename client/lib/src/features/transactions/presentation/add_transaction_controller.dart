import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction_model.dart';
import 'transaction_list_provider.dart';
import '../../dashboard/presentation/dashboard_controller.dart';

part 'add_transaction_controller.g.dart';

// 1. 상태 클래스 (State)
class AddTransactionState {
  final bool isLoading;
  final String? error;

  AddTransactionState({this.isLoading = false, this.error});
}

// 2. 뷰모델 (ViewModel / Controller)
@riverpod
class AddTransactionController extends _$AddTransactionController {
  @override
  AddTransactionState build() => AddTransactionState();

  Future<bool> submit({
    required String title,
    required int amount,
    required String type,
    required int categoryId,
    String? memo,
    required DateTime date,
  }) async {
    state = AddTransactionState(isLoading: true);

    try {
      final request = TransactionCreateRequest(
        title: title,
        amount: amount,
        type: type,
        categoryId: categoryId,
        memo: memo,
        transactionAt: date.toIso8601String(),
      );

      final repo = ref.read(transactionRepositoryProvider);
      await repo.createTransaction(request);

      // 성공 시 리스트 갱신
      ref.invalidate(transactionListProvider);
      ref.invalidate(dashboardControllerProvider);
      state = AddTransactionState(isLoading: false);
      return true;
    } catch (e) {
      state = AddTransactionState(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> update({
    required int id,
    required String title,
    required int amount,
    required String type,
    required int categoryId,
    String? memo,
    required DateTime date,
  }) async {
    state = AddTransactionState(isLoading: true);

    try {
      final request = TransactionCreateRequest(
        title: title,
        amount: amount,
        type: type,
        categoryId: categoryId,
        memo: memo,
        transactionAt: date.toIso8601String(),
      );

      final repo = ref.read(transactionRepositoryProvider);
      await repo.updateTransaction(id, request);

      ref.invalidate(transactionListProvider);
      state = AddTransactionState(isLoading: false);
      return true;
    } catch (e) {
      state = AddTransactionState(isLoading: false, error: e.toString());
      return false;
    }
  }
}

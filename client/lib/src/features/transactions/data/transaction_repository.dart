import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/transaction_model.dart';

part 'transaction_repository.g.dart';

// Repository 제공자
@riverpod
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepository(ref.watch(dioProvider));
}

// Category 리스트 요청 Provider
@riverpod
Future<List<CategoryModel>> categoryList(Ref ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getCategories();
}

class TransactionRepository {
  final Dio _dio;

  TransactionRepository(this._dio);

  // 거래내역 조회
  Future<List<TransactionModel>> getTransactions() async {
    final response = await _dio.get('/api/transactions');

    // 서버 응답을 하나씩 돌면서 모델로 변환
    final List<dynamic> data = response.data;
    print('📥 [DEBUG] Transactions data: $data'); // 디버깅용 로그
    return data.map((json) => TransactionModel.fromJson(json)).toList();
  }

  // 카테고리 목록 조회
  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/api/categories');

    final List<dynamic> data = response.data;
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  // 거래내역 생성(POST)
  Future<void> createTransaction(TransactionCreateRequest request) async {
    await _dio.post('/api/transactions', data: request.toJson());
  }

  // 삭제 기능
  Future<void> deleteTransaction(int id) async {
    try {
      await _dio.delete('/api/transactions/$id');
    } catch (e) {
      throw Exception('삭제 실패: $e');
    }
  }

  // 수정 기능
  Future<void> updateTransaction(
    int id,
    TransactionCreateRequest request,
  ) async {
    try {
      await _dio.put('/api/transactions/$id', data: request.toJson());
    } catch (e) {
      throw Exception('수정 실패: $e');
    }
  }
}

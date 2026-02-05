import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart'; // kIsWeb 사용을 위해 추가
import '../domain/transaction_model.dart';

part 'transaction_repository.g.dart';

// Dio 객체 제공자 (싱글톤처럼 관리)
@riverpod
Dio dio(DioRef ref) {
  // 웹(Chrome)이거나 iOS면 localhost, 안드로이드면 10.0.2.2
  final String baseUrl = kIsWeb 
      ? 'http://localhost:8080' 
      : 'http://10.0.2.2:8080';

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
  ));
  return dio;
}

// Repository 제공자
@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return TransactionRepository(ref.watch(dioProvider));
}

// Category 리스트 요청 Provider
@riverpod
Future<List<CategoryModel>> categoryList(CategoryListRef ref) async {
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
}
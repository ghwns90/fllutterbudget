import 'package:client/src/features/transactions/domain/transaction_model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import 'dashboard_response.dart';

part 'dashboard_repository.g.dart';

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepository(dio);
}

class DashboardRepository {
  final Dio _dio;
  DashboardRepository(this._dio);

  Future<DashboardResponse> getDashboard(String yearMonth) async {
    // yearMonth format: "2026-02"
    final response = await _dio.get(
      '/api/stats/dashboard',
      queryParameters: {'yearMonth': yearMonth}
    );
    return DashboardResponse.fromJson(response.data);
  }

  Future<List<DailyStat>> getTrend(String yearMonth) async {
    final response = await _dio.get(
      '/api/stats/trend', 
      queryParameters: { 'yearMonth' : yearMonth }
    );

    return (response.data as List).map((e) => DailyStat.fromJson(e)).toList();
  }

  Future<List<TransactionModel>> getHistory(String yearMonth, String type) async {
    final response = await _dio.get(
      '/api/stats/history',
      queryParameters: {
        'yearMonth' : yearMonth,
        'type' : type,
      }
    );

    return (response.data as List).map((e) => TransactionModel.fromJson(e)).toList();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/dashboard_repository.dart';
import '../data/dashboard_response.dart';

// 1. 현재 선택된 월을 관리하는 Provider
final currentMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// 2. 대시보드 데이터를 가져오는 Controller (Provider)
final dashboardControllerProvider = AsyncNotifierProvider.autoDispose<DashboardController, DashboardResponse>(DashboardController.new);

class DashboardController extends AutoDisposeAsyncNotifier<DashboardResponse> {
  @override
  Future<DashboardResponse> build() async {
    // 선택된 월이 바뀌면 자동으로 재실행됨
    final date = ref.watch(currentMonthProvider);
    final yearMonth = DateFormat('yyyy-MM').format(date);
    
    final repo = ref.watch(dashboardRepositoryProvider);
    return repo.getDashboard(yearMonth);
  }
}

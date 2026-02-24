import 'package:client/src/features/dashboard/data/dashboard_response.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/dashboard_repository.dart';

// 차트 데이터 Provider (Family: 월별로 데이터가 다름)
final trendProvider = FutureProvider.family.autoDispose<List<DailyStat>, String>((ref, yearMonth) async {
  return ref.watch(dashboardRepositoryProvider).getTrend(yearMonth);
});

class DashboardChart extends ConsumerWidget {
  final String yearMonth;
  const DashboardChart({required this.yearMonth, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(trendProvider(yearMonth));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: trendAsync.when(
          data: (data) => _buildChart(data),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('데이터 없음')),
        ),
      ),
    );
  }

  Widget _buildChart(List<DailyStat> data) {
    if (data.isEmpty) return const Center(child: Text('데이터가 없습니다.'));

    // x축 최대값 (말일) 계산
    final maxDay = DateTime(
      int.parse(yearMonth.split('-')[0]),
      int.parse(yearMonth.split('-')[1]) + 1,
      0
    ).day.toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.map((e) => e.amount).fold(0.0, (p,c) => p > c ? p : c) * 1.2,
        // max값 여유있게
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            tooltipMargin: 2, // 막대 위 여백
            tooltipPadding: EdgeInsets.zero,
            getTooltipColor: (_) => Colors.transparent, // 투명 배경
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                NumberFormat.compact(locale: "ko_KR").format(rod.toY),
                const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // 막대 아래에 간략하게 날짜 표시
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('${value.toInt()}일', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: data.map((stat) {
          return BarChartGroupData(
            x: stat.day,
            showingTooltipIndicators: [0], // 항상 금액 표시
            barRods: [
              BarChartRodData(
                toY: stat.amount,
                color: Colors.green.shade300,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
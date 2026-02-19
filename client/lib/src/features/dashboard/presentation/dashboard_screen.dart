import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/dashboard_response.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = ref.watch(currentMonthProvider);
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('대시보드'), centerTitle: true),
      body: Column(
        children: [
          // 1. Month Picker
          _buildMonthPicker(ref, currentMonth),

          // 2. Content
          Expanded(
            child: dashboardState.when(
              data: (data) => _buildDashboardContent(context, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPicker(WidgetRef ref, DateTime currentMonth) {
    final formatter = DateFormat('yyyy년 MM월');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            final newDate = DateTime(currentMonth.year, currentMonth.month - 1);
            ref.read(currentMonthProvider.notifier).state = newDate;
          },
        ),
        Text(
          formatter.format(currentMonth),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            final newDate = DateTime(currentMonth.year, currentMonth.month + 1);
            ref.read(currentMonthProvider.notifier).state = newDate;
          },
        ),
      ],
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardResponse data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCard(data), // 상단 요약
          const SizedBox(height: 32),
          if (data.categoryStats.isNotEmpty) ...[
            const Text(
              '지출 분석',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(height: 250, child: _buildPieChart(data.categoryStats)),
            const SizedBox(height: 24),
            _buildCategoryLegend(data.categoryStats),
          ] else
            const Padding(
              padding: EdgeInsets.all(40),
              child: Text('지출 내역이 없습니다.', style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(DashboardResponse data) {
    final formatter = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('이번 달 남은 돈', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              formatter.format(data.balance),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: data.balance >= 0
                    ? Colors.green.shade700
                    : Colors.red.shade700,
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem('수입', data.totalIncome, Colors.blue),
                _buildSummaryItem('지출', data.totalExpense, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    final formatter = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          formatter.format(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // [Design] 예쁜 파스텔 톤 색상 팔레트
  final List<Color> _chartColors = [
    const Color(0xFFFF6384), // Pink
    const Color(0xFF36A2EB), // Blue
    const Color(0xFFFFCE56), // Yellow
    const Color(0xFF4BC0C0), // Teal
    const Color(0xFF9966FF), // Purple
    const Color(0xFFFF9F40), // Orange
    const Color(0xFFC9CBCF), // Grey
  ];

  Widget _buildPieChart(List<CategoryStat> stats) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          final color = _chartColors[index % _chartColors.length];

          return PieChartSectionData(
            color: color,
            value: stat.percentage,
            title: '${stat.percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryLegend(List<CategoryStat> stats) {
    return Column(
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        final color = _chartColors[index % _chartColors.length];
        final formatter = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                stat.category,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(formatter.format(stat.totalAmount)),
              const SizedBox(width: 8),
              Text(
                '(${stat.percentage}%)',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

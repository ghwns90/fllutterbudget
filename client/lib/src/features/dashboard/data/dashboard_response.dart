
class CategoryStat {
  final String category;
  final double totalAmount;
  final double percentage;

  CategoryStat({
    required this.category,
    required this.totalAmount,
    required this.percentage,
  });

  factory CategoryStat.fromJson(Map<String, dynamic> json) {
    return CategoryStat(
      category: json['category'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

class DashboardResponse {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<CategoryStat> categoryStats;

  DashboardResponse({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.categoryStats,
  });

  factory DashboardResponse.fromJson(Map<String,dynamic> json) {
    return DashboardResponse(
      totalIncome: (json['totalIncome'] as num).toDouble(), 
      totalExpense: (json['totalExpense'] as num).toDouble(), 
      balance: (json['balance'] as num).toDouble(), 
      categoryStats: (json['categoryStats'] as List)
        .map((e) => CategoryStat.fromJson(e)).toList(),
    );
  }

}

class DailyStat {
  final int day;
  final double amount;

  DailyStat({required this.day, required this.amount});

  factory DailyStat.fromJson(Map<String, dynamic> json) {
    return DailyStat(day: json['day'] as int, amount: (json['amount'] as num).toDouble());
  } 
}
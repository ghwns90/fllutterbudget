import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final int id;
  final String title;
  final int amount;
  final String type;
  final String categoryName;
  final String categoryIcon;
  final String transactionAt;
  final String? memo;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryName,
    required this.categoryIcon,
    required this.transactionAt,
    this.memo,
  });

  // JSON -> 객체 변환
  factory TransactionModel.fromJson(Map<String, dynamic> json) => 
    _$TransactionModelFromJson(json);
}

@JsonSerializable()
class TransactionCreateRequest {
  final String title;
  final int amount;
  final String type;
  final int categoryId;
  final String? memo;
  final String transactionAt;

  TransactionCreateRequest({
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    this.memo,
    required this.transactionAt,
  });

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() => 
    _$TransactionCreateRequestToJson(this);
}

@JsonSerializable()
class CategoryModel {
  final int id;
  final String name;
  final String icon;

  CategoryModel({
    required this.id, required this.name, required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
}


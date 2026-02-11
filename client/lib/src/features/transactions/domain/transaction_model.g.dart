// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      amount: (json['amount'] as num).toInt(),
      type: json['type'] as String,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      categoryName: json['categoryName'] as String,
      categoryIcon: json['categoryIcon'] as String,
      transactionAt: json['transactionAt'] as String,
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'type': instance.type,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'categoryIcon': instance.categoryIcon,
      'transactionAt': instance.transactionAt,
      'memo': instance.memo,
    };

TransactionCreateRequest _$TransactionCreateRequestFromJson(
  Map<String, dynamic> json,
) => TransactionCreateRequest(
  title: json['title'] as String,
  amount: (json['amount'] as num).toInt(),
  type: json['type'] as String,
  categoryId: (json['categoryId'] as num).toInt(),
  memo: json['memo'] as String?,
  transactionAt: json['transactionAt'] as String,
);

Map<String, dynamic> _$TransactionCreateRequestToJson(
  TransactionCreateRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'amount': instance.amount,
  'type': instance.type,
  'categoryId': instance.categoryId,
  'memo': instance.memo,
  'transactionAt': instance.transactionAt,
};

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
    };

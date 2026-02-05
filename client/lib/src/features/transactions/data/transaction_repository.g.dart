// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'5cdba2e50667a95e5d7a257e5a597ee0d33748b4';

/// See also [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = AutoDisposeProviderRef<Dio>;
String _$transactionRepositoryHash() =>
    r'6db0c4dd5f5f708bdfadab5710707cd7e0fa9a90';

/// See also [transactionRepository].
@ProviderFor(transactionRepository)
final transactionRepositoryProvider =
    AutoDisposeProvider<TransactionRepository>.internal(
      transactionRepository,
      name: r'transactionRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionRepositoryRef =
    AutoDisposeProviderRef<TransactionRepository>;
String _$categoryListHash() => r'69389804ae6bb3cb8265a85a0dc44f60e06ad628';

/// See also [categoryList].
@ProviderFor(categoryList)
final categoryListProvider =
    AutoDisposeFutureProvider<List<CategoryModel>>.internal(
      categoryList,
      name: r'categoryListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryListRef = AutoDisposeFutureProviderRef<List<CategoryModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction_model.dart';
import 'transaction_list_provider.dart'; // 리스트 갱신용

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // 입력 값들
  String _type = 'EXPENSE';
  String _title = '';
  int _amount = 0;
  int? _categoryId;
  String _memo = '';
  DateTime _date = DateTime.now();

  // 저장 버튼 눌렀을때
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_categoryId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('카테고리를 선택해주세요')));
        return;
      }

      final request = TransactionCreateRequest(
        title: _title,
        amount: _amount,
        type: _type,
        categoryId: _categoryId!,
        memo: _memo,
        transactionAt: _date.toIso8601String(),
      );

      try {
        final repo = ref.read(transactionRepositoryProvider);

        await repo.createTransaction(request);

        // 리스트 새로고침 & 뒤로가기
        ref.invalidate(transactionListProvider);
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 서버에서 카테고리 목록 가져오기
    final asyncCategories = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('새 거래내역 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 카테고리 선택
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'EXPENSE',
                    label: Text('지출'),
                    icon: Icon(Icons.outbond),
                  ),
                  ButtonSegment(
                    value: 'INCOME',
                    label: Text('수입'),
                    icon: Icon(Icons.attach_money),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _type = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              //제목 입력
              TextFormField(
                decoration: const InputDecoration(labelText: '내용 (예: 점심값)'),
                validator: (value) =>
                    value == null || value.isEmpty ? '내용을 입력해주세요' : null,
                onSaved: (value) => _title = value!,
              ),

              // 금액 입력
              TextFormField(
                decoration: const InputDecoration(labelText: '금액'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? '금액을 입력해주세요' : null,
                onSaved: (value) => _amount = int.parse(value!),
              ),
              // 카테고리 선택
              asyncCategories.when(
                loading: () => const LinearProgressIndicator(),
                error: (err, _) => Text('카테고리 로딩 실패: $err'),
                data: (categories) => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: '카테고리'),
                  items: categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text('${c.icon}${c.name}'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _categoryId = value),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text('저장하기')),
            ], // children
          ), // ListView
        ), // Form
      ), // Padding
    ); // Scaffold
  } // build
} // addTransactionScreen

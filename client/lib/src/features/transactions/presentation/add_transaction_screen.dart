import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction_model.dart';
import 'transaction_list_provider.dart';

import 'add_transaction_controller.dart';

// 3. 화면 (UI)

// 3. 화면 (UI)
class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel? initialTransaction;
  const AddTransactionScreen({super.key, this.initialTransaction});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // 입력 값
  String _type = 'EXPENSE';
  String _title = '';
  int _amount = 0;
  int? _categoryId;
  String _memo = '';
  DateTime _date = DateTime.now();

  // [UI Helper] 날짜 선택기
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, // 달력 색상 커스텀
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_categoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('카테고리를 선택해주세요'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Controller에게 로직 위임
      bool success;
      if (widget.initialTransaction == null) {
        // 새로 만들기
        success = await ref
            .read(addTransactionControllerProvider.notifier)
            .submit(
              title: _title,
              amount: _amount,
              type: _type,
              categoryId: _categoryId!,
              memo: _memo,
              date: _date,
            );
      } else {
        // 수정하기
        success = await ref
            .read(addTransactionControllerProvider.notifier)
            .update(
              id: widget.initialTransaction!.id,
              title: _title,
              amount: _amount,
              type: _type,
              categoryId: _categoryId!,
              memo: _memo,
              date: _date,
            );
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('저장되었습니다'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.of(context).pop(); // GoRouter 대신 Navigator 사용
      } else {
        // 에러는 state.error에 있음 (필요 시 표시)
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // 수정 모드라면 초기값 설정
    if (widget.initialTransaction != null) {
      final t = widget.initialTransaction!;
      _title = t.title;
      _amount = t.amount;
      _type = t.type;
      _categoryId = t.categoryId;
      _memo = t.memo ?? '';
      _date = DateTime.parse(t.transactionAt); // String -> DateTime
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(addTransactionControllerProvider);
    final asyncCategories = ref.watch(categoryListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50], // 배경색을 은은하게
      appBar: AppBar(
        title: const Text(
          '내역 추가',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. 타입 선택 (커스텀 디자인)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _buildTypeButton('EXPENSE', '지출'),
                        _buildTypeButton('INCOME', '수입'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. 날짜 선택
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('yyyy년 MM월 dd일 (E)', 'ko').format(_date),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. 금액 입력 (가장 중요하게 보이도록)
                  TextFormField(
                    decoration: _inputDecoration(
                      '금액',
                      '0',
                      icon: Icons.attach_money,
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? '금액을 입력해주세요' : null,
                    onSaved: (value) => _amount = int.parse(value!),
                  ),
                  const SizedBox(height: 16),

                  // 4. 내용 입력
                  TextFormField(
                    decoration: _inputDecoration(
                      '내용',
                      '예: 점심 식사',
                      icon: Icons.edit,
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? '내용을 입력해주세요' : null,
                    onSaved: (value) => _title = value!,
                  ),
                  const SizedBox(height: 16),

                  // 5. 카테고리 선택
                  asyncCategories.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (err, _) =>
                        Text('카테고리 로딩 실패', style: TextStyle(color: Colors.red)),
                    data: (categories) => DropdownButtonFormField<int>(
                      decoration: _inputDecoration(
                        '카테고리',
                        '선택해주세요',
                        icon: Icons.category,
                      ),
                      items: categories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Row(
                                children: [
                                  Text(c.icon),
                                  const SizedBox(width: 8),
                                  Text(c.name),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _categoryId = value),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 6. 저장 버튼
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controllerState.isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _type == 'EXPENSE'
                            ? Colors.red[400]
                            : Colors.blue[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: controllerState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              '저장하기',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // [UI Helper] 타입 선택 버튼
  Widget _buildTypeButton(String type, String label) {
    final isSelected = _type == type;
    final color = type == 'EXPENSE' ? Colors.red : Colors.blue;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? color : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // [UI Helper] 공통 디자인 스타일
  InputDecoration _inputDecoration(
    String label,
    String hint, {
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey[400]) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green, width: 2),
      ),
    );
  }
}

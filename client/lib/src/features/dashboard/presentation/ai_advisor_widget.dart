import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_advisor_controller.dart';

class AiAdvisorWidget extends ConsumerWidget {
  final String yearMonth;
  const AiAdvisorWidget({required this.yearMonth, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 AI 분석 상태 (데이터가 있는지, 로딩중인지)
    final aiState = ref.watch(aiAdvisorControllerProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.purple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('AI 금융 비서의 한마디', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                const Spacer(),

                //분석하기 버튼
                if(!aiState.isLoading)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text('분석하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                    ),
                    onPressed: (){
                      ref.read(aiAdvisorControllerProvider.notifier).analyze(yearMonth);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // 상태에 따른 화면 렌더링
            aiState.when(
              data: (String? advice) {
                if(advice == null) {
                  return const Text('버튼을 눌러 이번 달 지출 내역을 분석해보세요', style: TextStyle(color: Colors.grey));
                }
                // 마크다운 형태의 텍스트가 오므로 간단한 위젯이나 Text로 쏴줌(추후 flutter_markdown 패키지를 쓰면 더 예쁨)
                return Text(advice, style: const TextStyle(height: 1.5));
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: Colors.indigo),
                )
              ),
              error: (e, s) => Text('분석 중 오류 발생: $e', style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/ai_advisor_repository.dart';

part 'ai_advisor_controller.g.dart';

// Family를 쓰지 않고 명시적으로 월(String)을 인자로 받는 컨트롤러
@riverpod
class AiAdvisorController extends _$AiAdvisorController {
  
  @override
  // 초기 상태는 null(아직 분석버튼 안 누름)
  AsyncValue<String?> build() {
    return const AsyncData(null);
  }

  Future<void> analyze(String yearMonth) async {
    // 로딩 상태 돌입(화면에서 스피너 돌게)
    state = const AsyncLoading();

    // 에러없이 성공하면 데이터를 state에 밀어넣음
    state = await AsyncValue.guard(() async {
      final repo = ref.read(aiAdvisorRepositoryProvider);
      return repo.getAdvice(yearMonth);
    });

  }
}
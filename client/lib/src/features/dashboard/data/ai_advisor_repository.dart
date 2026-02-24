import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';

part "ai_advisor_repository.g.dart";

@riverpod
AiAdvisorRepository aiAdvisorRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AiAdvisorRepository(dio);
}

class AiAdvisorRepository {

  final Dio _dio;

  AiAdvisorRepository(this._dio);

  Future<String> getAdvice(String yearMonth) async {
    final response = await _dio.get(
      "/api/ai/advisor", 
      queryParameters: {'yearMonth': yearMonth},);
      
    // {"advice" : "..."} 형태의 응답에서 문자열만 빼냄
    return response.data['advice'] as String;
  }  

}
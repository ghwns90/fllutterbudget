package com.example.budget.service;

import java.time.YearMonth;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.budget.dto.ai.AdvisorResponse;
import com.example.budget.dto.ai.AiRequest;
import com.example.budget.dto.ai.AiResponse;
import com.example.budget.dto.stat.DashboardResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.reactive.function.client.WebClient;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiAdvisorService {
    
    private final StatService statService; // 통계 데이터 조회용
    private final WebClient.Builder webClientBuilder;

    @Value("${gemini.api.url}")
    private String apiUrl;

    @Value("${gemini.api.key}")
    private String apiKey;

    public AdvisorResponse getAdvice(Long userId, YearMonth yearMonth) {
        
        log.info("AI 분석 시작 - User: {}, Month: {}", userId, yearMonth);

        // 내 지출 통계 데이터 가져오기 (데이터 수집)
        DashboardResponse stats = statService.getMonthlyDashboard(userId, yearMonth);

        // 프롬프트 엔지니어링 (명령어 조립)
        String prompt = buildPrompt(stats, yearMonth);
        log.info("생성된 프롬프트: \n{}", prompt);

        // WebClient로 구글 Gemini API 호출 (외부 API 연동)
        AiResponse response = webClientBuilder.build()
                                .post()
                                .uri(apiUrl + "?key=" + apiKey)
                                .bodyValue(AiRequest.of(prompt))
                                .retrieve()
                                .bodyToMono(AiResponse.class)
                                .block(); // 백엔드에서는 기다렸다가(block) 프론트로 리턴

        // 결과 파싱 및 반환
        return new AdvisorResponse(response.extractText());
    }

    // AI에게 역할을 부여하고 데이터를 주입하는 핵심 부분 (프롬프트 엔지니어링)
    private String buildPrompt(DashboardResponse stats, YearMonth yearMonth) {
        String categorySummary = stats.categoryStats()
            .stream()
            .map(c -> String.format("- %s: %s원 (%.1f%%)", c.category(), c.totalAmount().toPlainString(), c.percentage()))
            .collect(Collectors.joining("\n"));

        return String.format("""
                너는 20~30대 직장인을 위한 매우 친절하고 똑똑한 금융 비서야.
                아래는 사용자의 %s 데이터야. 이를 바탕으로 3가지 항목으로 잔소리 겸 재무 조언을 해줘.

                [사용자 데이터]
                - 총 수입: %s원
                - 총 지출: %s원
                - 남은 돈: %s원
                - 지출 분석 (카테고리별):
                %s

                [요구사항]
                1. 말투는 '~했어요', '~해보는건 어떨까요?' 처럼 부드럽고 친절하게 해줘.
                2. 가장 지출 비중이 큰 카테고리를 콕 집어서 조언해줘.
                3. 전체 글자 수는 500자를 넘지 않게 해줘.
                4. Markdown 리스트 형식(- )으로 응답해줘.
            """,
            yearMonth.toString(), // %s
            stats.totalIncome().toPlainString(),
            stats.totalExpense().toPlainString(),
            stats.balance().toPlainString(),
            categorySummary
        );
    }
    
}

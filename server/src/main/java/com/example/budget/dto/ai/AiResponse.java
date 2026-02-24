package com.example.budget.dto.ai;

import java.util.List;

public record AiResponse(List<Candidate> candidates) {
    public record Candidate(Content content) {}
    public record Content(List<Part> parts) {}
    public record Part(String text) {}

    // 응답 JSON에서 핵심 텍스트만 빼내는 유틸 메서드
    public String extractText() {
        if(candidates == null || candidates.isEmpty()) return "AI 분석에 실패했습니다.";
        return candidates.get(0).content().parts().get(0).text();
    }
}

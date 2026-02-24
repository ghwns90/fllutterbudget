package com.example.budget.dto.ai;

import java.util.List;

// Gemini API가 요구하는 JSON 구조
public record AiRequest(List<Content> contents) {
    public record Content(List<Part> parts){}
    public record Part(String text){}
    
    // 편하게 객체를 생성하기 위한 정적 팩토리 메서드
    public static AiRequest of(String prompt) {
        return new AiRequest(List.of(new Content(List.of(new Part(prompt)))));
    }
}

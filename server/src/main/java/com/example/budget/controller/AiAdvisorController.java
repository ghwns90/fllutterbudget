package com.example.budget.controller;

import java.time.YearMonth;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.budget.dto.ai.AdvisorResponse;
import com.example.budget.service.AiAdvisorService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/ai")
@RequiredArgsConstructor
public class AiAdvisorController {
    
    private final AiAdvisorService aiAdvisorService;

    // GET /api/ai/advisor?yearMonth=2026-02
    @GetMapping("/advisor")
    public AdvisorResponse getAdvice(
        @AuthenticationPrincipal Long userId,
        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM") YearMonth yearMonth
    ) {
        if(yearMonth == null) {
            yearMonth = YearMonth.now();
        }
        
        return aiAdvisorService.getAdvice(userId, yearMonth);
    }
}

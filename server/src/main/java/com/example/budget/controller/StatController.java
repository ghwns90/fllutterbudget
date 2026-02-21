package com.example.budget.controller;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.budget.domain.TransactionType;
import com.example.budget.dto.TransactionResponse;
import com.example.budget.dto.stat.DailyStatDto;
import com.example.budget.dto.stat.DashboardResponse;
import com.example.budget.service.StatService;
import java.time.YearMonth;
import java.util.List;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/stats")
@RequiredArgsConstructor
public class StatController {
    
    private final StatService statService;
    
    // GET /api/stats/dashboard?yearMonth=2026-02
    @GetMapping("/dashboard")
    public DashboardResponse getDashboard(
        @AuthenticationPrincipal Long userId,
        @RequestParam(required = false) 
        @DateTimeFormat(pattern = "yyyy-MM") YearMonth yearMonth
    ) {
        // 파라미터 없으면 현재 날짜 기준
        if(yearMonth == null) {
            yearMonth = YearMonth.now();
        }

        return statService.getMonthlyDashboard(userId, yearMonth);
    }

    @GetMapping("/trend")
    public List<DailyStatDto> getTrend(
        @AuthenticationPrincipal Long userId,
        @RequestParam @DateTimeFormat(pattern = "yyyy-MM") YearMonth yearMonth
    ) {
        return statService.getDailyTrend(userId, yearMonth);
    }

    @GetMapping("/history")
    public List<TransactionResponse> getHistory(
        @AuthenticationPrincipal Long userId,
        @RequestParam @DateTimeFormat(pattern = "yyyy-MM") YearMonth yearMonth,
        @RequestParam TransactionType type
    ) {
        return statService.getHistory(userId, yearMonth, type);
    }
}

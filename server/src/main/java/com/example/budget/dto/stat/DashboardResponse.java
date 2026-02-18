package com.example.budget.dto.stat;

import java.math.BigDecimal;
import java.util.List;

public record DashboardResponse (
    BigDecimal totalIncome, // 총 수입
    BigDecimal totalExpense, // 총 지출
    BigDecimal balance, // 남은 돈
    List<CategoryStatDto> categoryStats // 카테고리별 분석
) {}

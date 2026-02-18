package com.example.budget.dto.stat;

import java.math.BigDecimal;

public record CategoryStatDto (
    String category,
    BigDecimal totalAmount,
    Double percentage // 전체 지출 대비 비중
) {}
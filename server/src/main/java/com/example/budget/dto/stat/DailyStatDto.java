package com.example.budget.dto.stat;

import java.math.BigDecimal;

public record DailyStatDto(
    Integer day,
    BigDecimal amount
) {

}

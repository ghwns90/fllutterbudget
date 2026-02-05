package com.example.budget.dto;

import com.example.budget.domain.TransactionType;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public record TransactionCreateRequest(
    @NotBlank(message = "제목은 필수입니다.") String title,

    @NotNull(message = "금액은 필수입니다") @Min(value = 0, message = "금액은 0원 이상이어야 합니다.") BigDecimal amount,

    @NotNull(message = "수입/지출 타입을 선택해주세요.") TransactionType type, // ENUM 타입 INCOME or EXPENSE

    @NotNull(message = "카테고리 ID가 필요합니다.") Long categoryId,

    String memo,

    LocalDateTime transactionAt // 거래시간

) {
}
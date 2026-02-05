package com.example.budget.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.example.budget.domain.Transaction;

import lombok.Getter;

@Getter
public class TransactionResponse {

  private final Long id;
  private final String title;
  private final BigDecimal amount;
  private final String type;
  private final String categoryName;

  private final String categoryIcon;
  private final LocalDateTime transactionAt;

  private final String memo;

  public TransactionResponse(Transaction transaction) {
    this.id = transaction.getId();
    this.title = transaction.getTitle();
    this.amount = transaction.getAmount();
    this.type = transaction.getType().name(); // Enum -> String
    this.transactionAt = transaction.getTransactionAt();
    this.memo = transaction.getMemo();

    // 연관된 카테고리 정보 가져오기
    if(transaction.getCategory() != null) {
      this.categoryName = transaction.getCategory().getName();
      this.categoryIcon = transaction.getCategory().getIcon();
    } else {
      this.categoryName = "미분류";
      this.categoryIcon = "❓";
    }
  }
}
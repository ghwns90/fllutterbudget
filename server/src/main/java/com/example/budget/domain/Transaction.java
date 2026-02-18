package com.example.budget.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Getter @Setter
@NoArgsConstructor
@Table(name = "transactions")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title; // 내역명 (스타벅스, 월급)

    @Column(nullable = false)
    private BigDecimal amount; // 금액 (실무 표준: BigDecimal)

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TransactionType type; // INCOME, EXPENSE

    @Column(nullable = false)
    private LocalDateTime transactionAt; // 거래 일시

    private String memo; // 메모 (선택)

    // 관계 매핑 (N:1)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    // 생성자 패턴 대신 Builder 패턴 추천 (추후 적용)
}

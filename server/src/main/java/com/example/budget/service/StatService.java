package com.example.budget.service;

import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.math.BigDecimal;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.budget.repository.TransactionRepository;
import com.example.budget.domain.TransactionType;
import com.example.budget.dto.TransactionResponse;
import com.example.budget.dto.stat.CategoryStatDto;
import com.example.budget.dto.stat.DailyStatDto;
import com.example.budget.dto.stat.DashboardResponse;

import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StatService {
    
    private final TransactionRepository transactionRepository;

    public DashboardResponse getMonthlyDashboard(Long userId, YearMonth yearMonth) {
        // 날짜 범위 계산 (LocalDateTime 변환)
        LocalDateTime startDate = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endDate = yearMonth.atEndOfMonth().atTime(java.time.LocalTime.MAX);

        // 총 수입/지출 조회 (NULL일 경우 0으로 처리)
        BigDecimal totalIncome = transactionRepository.sumAmountByUserAndTypeAndDateBetween(
                userId, TransactionType.INCOME, startDate, endDate);
        if (totalIncome == null) totalIncome = BigDecimal.ZERO;

        BigDecimal totalExpense = transactionRepository.sumAmountByUserAndTypeAndDateBetween(
                userId, TransactionType.EXPENSE, startDate, endDate);
        if (totalExpense == null) totalExpense = BigDecimal.ZERO;

        // 카테고리별 통계 조회
        List<CategoryStatDto> categoryStats = transactionRepository.findCategoryStats(userId, startDate, endDate);

        // % 계산 로직
        // BigDecimal 나눗셈: divide(divisor, scale, roundingMode)
        // 지출이 0원이면 나눗셈 에러가 발생하므로 체크 필수
        final BigDecimal finalTotalExpense = totalExpense;
        if (finalTotalExpense.compareTo(BigDecimal.ZERO) > 0) {
            categoryStats = categoryStats.stream().map(stat -> {
                BigDecimal amount = stat.totalAmount();
                // (해당 카테고리 지출 / 총 지출) * 100
                // 소수점 1자리까지 반올림 (RoundingMode.HALF_UP)
                double percentage = amount.divide(finalTotalExpense, 4, java.math.RoundingMode.HALF_UP)
                        .multiply(BigDecimal.valueOf(100))
                        .doubleValue();
                
                return new CategoryStatDto(
                        stat.category(),
                        amount,
                        percentage
                );
            }).collect(Collectors.toList());
        }

        // 잔액 = 수입 - 지출
        BigDecimal balance = totalIncome.subtract(totalExpense);

        return new DashboardResponse(
                totalIncome,
                totalExpense,
                balance,
                categoryStats
        );
    }

    // 일별 추이 데이터
    public List<DailyStatDto> getDailyTrend(Long userId, YearMonth yearMonth) {
        LocalDateTime startDate = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endDate = yearMonth.atEndOfMonth().atTime(java.time.LocalTime.MAX);

        return transactionRepository.findDailyStats(userId, startDate, endDate);
    }

    // 탭 리스트 데이터
    public List<TransactionResponse> getHistory(Long userId, YearMonth yearMonth, TransactionType type) {
        LocalDateTime startDate = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endDate = yearMonth.atEndOfMonth().atTime(java.time.LocalTime.MAX);

        return transactionRepository
                .findByUserIdAndTypeAndTransactionAtBetweenOrderByTransactionAtDesc(
                        userId, type, startDate, endDate)
                .stream()
                .map(TransactionResponse::new)
                .collect(Collectors.toList());

    }

}

package com.example.budget.repository;

import java.time.LocalDateTime;
import java.math.BigDecimal;
import com.example.budget.domain.Transaction;
import com.example.budget.domain.TransactionType;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.example.budget.dto.stat.CategoryStatDto;
import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
  
    // 특정 기간 동안의 수입/지출 합계 조회
    @Query("SELECT SUM(t.amount) FROM Transaction t "
        + "WHERE t.user.id = :userId AND t.type = :type "
        + "AND t.transactionAt BETWEEN :startDate AND :endDate")
    BigDecimal sumAmountByUserAndTypeAndDateBetween(
        @Param("userId") Long userId,
        @Param("type") TransactionType type,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );

    // 카테고리별 지출 통계 (Group By)
    // DTO로 바로 매핑하기 위해 new 구문 사용 (t.category -> t.category.name)
    @Query("SELECT new com.example.budget.dto.stat.CategoryStatDto(t.category.name, SUM(t.amount), 0.0) "
        + "FROM Transaction t " 
        + "WHERE t.user.id = :userId AND t.type = 'EXPENSE' "
        + "AND t.transactionAt BETWEEN :startDate AND :endDate " 
        + "GROUP BY t.category.name "
        + "ORDER BY SUM(t.amount) DESC")
    List<CategoryStatDto> findCategoryStats(
        @Param("userId") Long userId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
}
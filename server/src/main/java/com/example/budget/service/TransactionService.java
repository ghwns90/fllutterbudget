package com.example.budget.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.budget.domain.Category;
import com.example.budget.domain.Transaction;
import com.example.budget.dto.TransactionCreateRequest;
import com.example.budget.dto.TransactionResponse;
import com.example.budget.repository.CategoryRepository;
import com.example.budget.repository.TransactionRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TransactionService {

  private final TransactionRepository transactionRepository;
  private final CategoryRepository categoryRepository;

  // 거래 내역 생성(Create)
  @Transactional
  public TransactionResponse createTransaction(TransactionCreateRequest request) {

    // 카테고리 조회
    Category category = categoryRepository.findById(request.categoryId())
        .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 카테고리입니다."));

    // transcation 엔티티 생성
    Transaction transaction = new Transaction();
    transaction.setTitle(request.title());
    transaction.setAmount(request.amount());
    transaction.setType(request.type());
    transaction.setCategory(category);
    transaction.setMemo(request.memo());
    transaction.setTransactionAt(request.transactionAt());

    // DB 저장
    Transaction savedTransaction = transactionRepository.save(transaction);

    // 응답 DTO로 변환해서 변환
    return new TransactionResponse(savedTransaction);
    
  };

  // 거래 내역 조회 (Read One)
  public TransactionResponse getTransaction(Long id) {
    Transaction transaction = transactionRepository.findById(id)
        .orElseThrow(() -> new IllegalArgumentException("해당 내역을 찾을 수 없습니다. (id: " + id + ")"));

    return new TransactionResponse(transaction);    
  }

  // 전체 내역 조회 (List)
  public List<TransactionResponse> getTransactions() {
    return transactionRepository.findAll().stream()
        .map(TransactionResponse::new)
        .collect(Collectors.toList());
  }

}

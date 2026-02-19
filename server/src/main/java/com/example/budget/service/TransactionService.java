package com.example.budget.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.budget.domain.Category;
import com.example.budget.domain.Transaction;
import com.example.budget.dto.TransactionCreateRequest;
import com.example.budget.dto.TransactionResponse;
import com.example.budget.domain.User;
import com.example.budget.repository.CategoryRepository;
import com.example.budget.repository.TransactionRepository;
import com.example.budget.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TransactionService {

  private final TransactionRepository transactionRepository;
  private final CategoryRepository categoryRepository;
  private final UserRepository userRepository;

  // 거래 내역 생성(Create)
  @Transactional
  public TransactionResponse createTransaction(Long userId, TransactionCreateRequest request) {
    // 유저 조회
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

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
    transaction.setUser(user); // 유저 연결

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

  // 전체 내역 조회 (List) - 유저별 조회
  public List<TransactionResponse> getTransactions(Long userId) {
    return transactionRepository.findAllByUserId(userId).stream()
        .map(TransactionResponse::new)
        .collect(Collectors.toList());
  }

  // 삭제 (Delete)
  @Transactional
  public void deleteTransaction(Long id) {
    transactionRepository.deleteById(id);
  }

  // 수정 (Update)
  @Transactional
  public TransactionResponse updateTransaction(Long id, TransactionCreateRequest request) {
    Transaction transaction = transactionRepository.findById(id)
        .orElseThrow(() -> new IllegalArgumentException("해당 내역을 찾을 수 없습니다. (id: " + id + ")"));

    // 카테고리 조회
    Category category = categoryRepository.findById(request.categoryId())
        .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 카테고리입니다."));

    transaction.setTitle(request.title());
    transaction.setAmount(request.amount());
    transaction.setType(request.type());
    transaction.setCategory(category);
    transaction.setMemo(request.memo());
    transaction.setTransactionAt(request.transactionAt());

    return new TransactionResponse(transaction);
  }

}

package com.example.budget.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.budget.dto.TransactionCreateRequest;
import com.example.budget.dto.TransactionResponse;
import com.example.budget.service.TransactionService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/transactions")
public class TransactionController {
  
  private final TransactionService transactionService;

  // 거래 내역 기록 (POST, /api/transactions)
  @PostMapping
  public TransactionResponse createTransaction(
    @RequestBody @Valid TransactionCreateRequest request
  ) {
    return transactionService.createTransaction(request);
  }

  // 거래 내역 목록 조회 (GET, /api/transactions)
  @GetMapping
  public List<TransactionResponse> getTransactions() {
    return transactionService.getTransactions();
  }

  // 거래 내역 상세 조회 (GET, /api/transactions/{id})
  @GetMapping("/{id}")
  public TransactionResponse getTransaction(@PathVariable("id") Long id) {
    return transactionService.getTransaction(id);
  }

  // 거래 내역 삭제 (DELETE, /api/transactions/{id})
  @DeleteMapping("/{id}")
  public void deleteTransaction(@PathVariable("id") Long id) {
    transactionService.deleteTransaction(id);
  }

  // 거래 내역 수정 (PUT, /api/transactions/{id})
  @PutMapping("/{id}")
  public TransactionResponse updateTransaction(
    @PathVariable("id") Long id,
    @RequestBody @Valid TransactionCreateRequest request
  ) {
    return transactionService.updateTransaction(id, request);
  }

}

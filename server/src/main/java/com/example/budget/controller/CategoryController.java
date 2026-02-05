package com.example.budget.controller;

import com.example.budget.domain.Category;
import com.example.budget.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryRepository categoryRepository;

    // 카테고리 전체 조회 (GET /api/categories)
    @GetMapping
    public List<Category> getCategories() {
        return categoryRepository.findAll();
    }
}
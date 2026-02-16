package com.example.budget.dto;

public record AuthRequest(
        String email,
        String password,
        String name
) {

}

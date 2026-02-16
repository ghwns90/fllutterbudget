package com.example.budget.dto;

public record TokenResponse(
    String accessToken,
    String refreshToken
) {

}

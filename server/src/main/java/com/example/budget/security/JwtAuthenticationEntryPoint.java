package com.example.budget.security;

import java.io.IOException;
import java.time.LocalDateTime;

import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException authException) throws IOException, ServletException {
        
        // 401 에러 설정
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setCharacterEncoding("UTF-8");

        // ErrorResponse 객체 생성 (record라 new 대신 바로 생성)
        // timestamp 직렬화를 위해 jackson-datatype-jsr310 필요할 수 있음.
        // 간단하게 Map을 쓰거나 커스텀 DTO를 직접 JSON 문자열로 만들어도 되지만, 
        // ObjectMapper를 쓰는게 깔끔함.
        
        var errorResponse = new ErrorResponseForSecurity(
            LocalDateTime.now().toString(),
            HttpServletResponse.SC_UNAUTHORIZED,
            "Unauthorized",
            "인증이 필요합니다. (토큰이 없거나 만료되었습니다)",
            request.getRequestURI()
        );

        objectMapper.writeValue(response.getOutputStream(), errorResponse);
    }

    // Security 패키지 내부에서만 쓸 간단한 DTO (record)
    record ErrorResponseForSecurity(
        String timestamp,
        int status,
        String error,
        String message,
        String path
    ) {}
}

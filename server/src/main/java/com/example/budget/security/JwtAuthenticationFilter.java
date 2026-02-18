package com.example.budget.security;

import java.io.IOException;
import java.util.Collections;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        final String authHeader = request.getHeader("Authorization");
        final String jwt;
        final Long userId;

        // 1. 헤더 검사
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        jwt = authHeader.substring(7);

        // 2. 토큰 유효성 검사
        if (jwtUtil.validateToken(jwt)) {
            userId = jwtUtil.getUserId(jwt);
            // email은 claim에서 꺼낼 수 있도록 JwtUtil에 메서드 추가 필요하지만, 
            // 일단 userId만 principal로 설정해도 됨.
            
            // 3. 인증 객체 생성 (권한은 일단 비워둠)
            UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                    userId, // Principal (나중에 @AuthenticationPrincipal로 꺼내 쓸 값)
                    null,
                    Collections.emptyList() // Authorities
            );

            authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

            // 4. SecurityContext에 저장
            SecurityContextHolder.getContext().setAuthentication(authToken);
        }

        filterChain.doFilter(request, response);
    }
}

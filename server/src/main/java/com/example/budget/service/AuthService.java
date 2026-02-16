package com.example.budget.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.budget.domain.User;
import com.example.budget.dto.AuthRequest;
import com.example.budget.dto.LoginRequest;
import com.example.budget.dto.TokenResponse;
import com.example.budget.repository.UserRepository;
import com.example.budget.security.JwtUtil;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    @Transactional
    public TokenResponse signup(AuthRequest request) {
        if(userRepository.findByEmail(request.email()).isPresent()) {
            throw new IllegalArgumentException("이미 가입된 이메일입니다");
        }

        User user = new User();
        user.setEmail(request.email());
        user.setPassword(passwordEncoder.encode(request.password()));
        user.setName(request.name());

        User saved = userRepository.save(user);

        return issueTokens(saved);
    }

    @Transactional
    public TokenResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.email())
            .orElseThrow(() -> new IllegalArgumentException("계정을 찾을 수 없습니다"));

        if(!passwordEncoder.matches(request.password(), user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 틀렸습니다.");
        }

        return issueTokens(user);
    }

    // 토큰 재발급
    @Transactional
    public TokenResponse refreshToken(String refreshToken) {

        // 토큰 유효성 검사
        if (!jwtUtil.validateToken(refreshToken)) {
            throw new IllegalArgumentException("유효하지 않은 refresh token 입니다");
        }

        // db 확인
        User user = userRepository.findByRefreshToken(refreshToken)
            .orElseThrow(() -> new IllegalArgumentException("토큰이 만료되었거나 존재하지 않습니다."));

        return issueTokens(user);
    }
    

    @Transactional
    public TokenResponse issueTokens(User user) {
        String accessToken = jwtUtil.generateAccessToken(user.getId(), user.getEmail());
        String refreshToken = jwtUtil.generateAccessToken(user.getId(), user.getEmail());

        user.setRefreshToken(refreshToken); // db 업데이트
        // 실제 저장 로직은 @Transactional 안에서 dirty checking으로 수행됨

        return new TokenResponse(accessToken, refreshToken);
    }
}

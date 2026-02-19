INSERT INTO categories (name, icon) VALUES ('식비', '🍔');
INSERT INTO categories (name, icon) VALUES ('교통비', '🚌');
INSERT INTO categories (name, icon) VALUES ('쇼핑', '🛍️');
INSERT INTO categories (name, icon) VALUES ('월급', '💰');
INSERT INTO categories (name, icon) VALUES ('기타', '🎸');

-- 비밀번호: 1234 (BCrypt Encoded)
INSERT INTO users (email, password, name) VALUES ('test@test.com', '$2a$10$.it5EWlXbpu1/hvqsmIj3enLtJ.HzUm6vtp2czHzbd31aSV4njjZa', '테스터');

INSERT INTO transactions (title, amount, type, category_id, memo, transaction_at, user_id) 
VALUES ('점심 식사 (김치찌개)', 9000, 'EXPENSE', 1, '맛있었다', '2024-05-20T12:30:00', 1);

INSERT INTO transactions (title, amount, type, category_id, memo, transaction_at, user_id)
VALUES ('월급', 3000000, 'INCOME', 4, '금융치료', '2024-05-25T10:00:00', 1);
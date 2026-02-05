INSERT INTO categories (name, icon) VALUES ('식비', '🍔');
INSERT INTO categories (name, icon) VALUES ('교통비', '🚌');
INSERT INTO categories (name, icon) VALUES ('쇼핑', '🛍️');
INSERT INTO categories (name, icon) VALUES ('월급', '💰');
INSERT INTO categories (name, icon) VALUES ('기타', '🎸');

INSERT INTO transactions (title, amount, type, category_id, memo, transaction_at) 
VALUES ('점심 식사 (김치찌개)', 9000, 'EXPENSE', 1, '맛있었다', '2024-05-20T12:30:00');
INSERT INTO transactions (title, amount, type, category_id, memo, transaction_at)
VALUES ('월급', 3000000, 'INCOME', 4, '금융치료', '2024-05-25T10:00:00');
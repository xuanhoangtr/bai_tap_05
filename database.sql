-- ============================================================
-- SCRIPT TẠO CƠ SỞ DỮ LIỆU POSTGRESQL CHO DỰ ÁN BÀI TẬP 05
-- SPRING BOOT 4.0.0 & JSP/JSTL (ADMIN CRUD)
-- ============================================================

-- 1. TẠO BẢNG CATEGORIES
CREATE TABLE IF NOT EXISTS categories (
    categoryid SERIAL PRIMARY KEY,
    categoryname VARCHAR(255) NOT NULL,
    images VARCHAR(500),
    status INT DEFAULT 1,
    CONSTRAINT uk_categories_name UNIQUE (categoryname)
);

-- Tạo chỉ mục chống trùng lặp không phân biệt hoa thường (Case-Insensitive Unique Index)
CREATE UNIQUE INDEX IF NOT EXISTS uk_categories_name_lower 
ON categories (LOWER(TRIM(categoryname)));


-- 2. TẠO BẢNG USERS
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    fullname VARCHAR(100),
    phone VARCHAR(20),
    images VARCHAR(500),
    role VARCHAR(20) DEFAULT 'USER',
    status INT DEFAULT 1,
    otp VARCHAR(10),
    otp_expiry TIMESTAMP,
    CONSTRAINT uk_users_username UNIQUE (username),
    CONSTRAINT uk_users_email UNIQUE (email)
);

-- Tạo chỉ mục chống trùng lặp username và email không phân biệt hoa thường
CREATE UNIQUE INDEX IF NOT EXISTS uk_users_username_lower 
ON users (LOWER(TRIM(username)));

CREATE UNIQUE INDEX IF NOT EXISTS uk_users_email_lower 
ON users (LOWER(TRIM(email)));


-- 3. CHÈN DỮ LIỆU MẪU BAN ĐẦU
-- Tài khoản Quản trị viên mặc định: xuan / 123 (Role ADMIN)
INSERT INTO users (username, password, email, fullname, phone, images, role, status)
VALUES 
    ('xuan', '123', 'xuanhoangtr@gmail.com', 'Tran Xuan Hoang', '0987654321', 'avatar.png', 'ADMIN', 1),
    ('user1', '123456', 'user1@gmail.com', 'Nguyen Van A', '0912345678', 'avatar.png', 'USER', 1)
ON CONFLICT (username) DO NOTHING;

-- Dữ liệu danh mục sản phẩm mẫu
INSERT INTO categories (categoryname, images, status)
VALUES 
    ('Điện thoại thông minh', 'avatar.png', 1),
    ('Laptop & Máy tính bảng', 'avatar.png', 1),
    ('Tai nghe & Âm thanh', 'avatar.png', 1),
    ('Đồng hồ thông minh', 'avatar.png', 1),
    ('Phụ kiện & Cáp sạc', 'avatar.png', 1)
ON CONFLICT (categoryname) DO NOTHING;

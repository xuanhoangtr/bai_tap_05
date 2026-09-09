<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/></title>
    
    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8fafc; min-height: 100vh; display: flex; flex-direction: column; color: #334155; }
        .main-content { flex: 1; padding: 30px 0; }
        .footer { background-color: #1e293b; color: #94a3b8; padding: 20px 0; margin-top: auto; font-size: 13px; }
    </style>
    <sitemesh:write property="head"/>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="<c:url value='/admin/dashboard'/>">
                HỆ THỐNG QUẢN TRỊ ADMIN
            </a>
            <div class="ms-auto">
                <a href="<c:url value='/admin/dashboard'/>" class="btn btn-outline-light btn-sm">Vào Trang Quản Trị</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <div class="container">
            <sitemesh:write property="body"/>
        </div>
    </main>

    <footer class="footer text-center">
        <div class="container">
            <p class="mb-0">Hệ thống Quản lý Bán hàng</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

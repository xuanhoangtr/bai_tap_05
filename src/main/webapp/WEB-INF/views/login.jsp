<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Quản trị Hệ thống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }
        .login-card {
            max-width: 420px;
            width: 100%;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            overflow: hidden;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card login-card border-0">
                    <div class="card-header bg-primary text-white text-center py-4">
                        <h4 class="fw-bold mb-1">HỆ THỐNG QUẢN TRỊ</h4>
                        <div class="small opacity-75">Đăng nhập tài khoản quản trị viên</div>
                    </div>
                    <div class="card-body p-4 bg-white">
                        <c:if test="${not empty message}">
                            <div class="alert alert-success small alert-dismissible fade show" role="alert">
                                ${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger small alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="<c:url value='/login'/>" method="POST">
                            <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}" />

                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold text-secondary">Tên đăng nhập</label>
                                <input type="text" class="form-control" id="username" name="username" 
                                       placeholder="Ví dụ: xuan" value="${username}" required autofocus>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label fw-semibold text-secondary">Mật khẩu</label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       placeholder="Nhập mật khẩu..." required>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm">
                                Đăng nhập hệ thống
                            </button>
                        </form>
                    </div>
                    <div class="card-footer bg-light text-center py-3 border-0 small text-muted">
                        Tài khoản Admin mặc định: <b>xuan</b> / <b>123</b>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

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
        :root {
            --sidebar-width: 260px;
            --primary-color: #0d6efd;
            --dark-sidebar: #1e293b;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f8fafc;
            color: #334155;
            min-height: 100vh;
            display: flex;
        }
        .admin-sidebar {
            width: var(--sidebar-width);
            background-color: var(--dark-sidebar);
            color: #f8fafc;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
        }
        .sidebar-brand {
            padding: 20px;
            font-size: 16px;
            font-weight: bold;
            color: #ffffff;
            border-bottom: 1px solid #334155;
            text-decoration: none;
            letter-spacing: 0.5px;
            display: block;
        }
        .sidebar-menu {
            padding: 15px 0;
            list-style: none;
            margin: 0;
            flex: 1;
        }
        .sidebar-header {
            padding: 10px 20px 5px;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #94a3b8;
            font-weight: 700;
        }
        .sidebar-item a {
            display: flex;
            align-items: center;
            padding: 11px 20px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            border-left: 3px solid transparent;
            transition: all 0.2s ease;
        }
        .sidebar-item a:hover {
            background-color: #334155;
            color: #ffffff;
            border-left-color: var(--primary-color);
        }
        .sidebar-item a.active {
            background-color: #0f172a;
            color: #ffffff;
            border-left-color: var(--primary-color);
            font-weight: 600;
        }
        .admin-main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
        }
        .admin-topbar {
            background-color: #ffffff;
            border-bottom: 1px solid #e2e8f0;
            padding: 12px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }
        .admin-content {
            flex: 1;
            padding: 30px;
            max-width: 1400px;
            width: 100%;
        }
        .admin-footer {
            background-color: #ffffff;
            border-top: 1px solid #e2e8f0;
            padding: 15px 30px;
            text-align: center;
            font-size: 13px;
            color: #64748b;
        }
        .user-badge-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            border: 1.5px solid #0d6efd;
            background: #e2e8f0;
        }
    </style>
    <sitemesh:write property="head"/>
</head>
<body>

    <!-- Sidebar Navigation -->
    <aside class="admin-sidebar">
        <a href="<c:url value='/admin/dashboard'/>" class="sidebar-brand">
            HỆ THỐNG QUẢN TRỊ ADMIN
        </a>
        <ul class="sidebar-menu">
            <li class="sidebar-header">Tổng quan</li>
            <li class="sidebar-item">
                <a href="<c:url value='/admin/dashboard'/>">Bảng điều khiển</a>
            </li>

            <li class="sidebar-header">Quản lý nội dung</li>
            <li class="sidebar-item">
                <a href="<c:url value='/admin/categories'/>">Danh mục sản phẩm</a>
            </li>
            <li class="sidebar-item">
                <a href="<c:url value='/admin/categories/add'/>">Thêm danh mục mới</a>
            </li>

            <li class="sidebar-header">Người dùng &amp; Tài khoản</li>
            <li class="sidebar-item">
                <a href="<c:url value='/admin/users'/>">Danh sách người dùng</a>
            </li>
            <li class="sidebar-item">
                <a href="<c:url value='/admin/users/add'/>">Thêm người dùng mới</a>
            </li>
        </ul>
    </aside>

    <!-- Main Content Wrapper -->
    <div class="admin-main-wrapper">
        <!-- Topbar -->
        <header class="admin-topbar">
            <div class="fw-bold text-primary">
                HỆ THỐNG QUẢN TRỊ BÁN HÀNG
            </div>
            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.adminUser}">
                        <div class="d-flex align-items-center gap-2">
                            <img src="<c:url value='/image?fname=${sessionScope.adminUser.images}'/>" class="user-badge-avatar" alt="Avatar" />
                            <div class="small">
                                <div class="fw-bold">${sessionScope.adminUser.fullname}</div>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                    ${sessionScope.adminUser.role}
                                </span>
                            </div>
                        </div>
                        <a href="<c:url value='/logout'/>" class="btn btn-outline-danger btn-sm">
                            Đăng xuất
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="<c:url value='/login'/>" class="btn btn-primary btn-sm">
                            Đăng nhập
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <!-- Main Content Area Decorated by SiteMesh 3 -->
        <main class="admin-content">
            <!-- Flash Message Alerts -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <sitemesh:write property="body"/>
        </main>

        <!-- Footer -->
        <footer class="admin-footer">
            <div><b>Hệ thống Quản lý Bán hàng &amp; Phân quyền Admin</b></div>
        </footer>
    </div>

    <!-- Bootstrap 5.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

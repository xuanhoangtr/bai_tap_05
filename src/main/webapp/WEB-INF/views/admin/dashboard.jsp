<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Bảng điều khiển Quản trị</title>
</head>
<body>

    <!-- Header Page -->
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <div>
            <h4 class="fw-bold text-dark mb-1">BẢNG ĐIỀU KHIỂN QUẢN TRỊ</h4>
            <p class="text-muted small mb-0">Tổng quan hệ thống, quản lý danh mục và người dùng.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="<c:url value='/admin/categories/add'/>" class="btn btn-primary btn-sm fw-semibold">
                Thêm danh mục
            </a>
            <a href="<c:url value='/admin/users/add'/>" class="btn btn-outline-primary btn-sm fw-semibold">
                Thêm người dùng
            </a>
        </div>
    </div>

    <!-- Metric Cards -->
    <div class="row g-4 mb-4">
        <!-- Card Categories -->
        <div class="col-md-6 col-lg-6">
            <div class="card border-0 shadow-sm rounded-3 h-100">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase small fw-bold">Tổng số danh mục</span>
                            <h2 class="fw-bold text-primary mt-2 mb-0">${totalCategories}</h2>
                        </div>
                        <div class="p-3 bg-primary-subtle text-primary rounded-circle">
                            <span class="fw-bold fs-4">C</span>
                        </div>
                    </div>
                    <div class="mt-3 pt-3 border-top d-flex justify-content-between align-items-center">
                        <a href="<c:url value='/admin/categories'/>" class="text-decoration-none small fw-semibold text-primary">
                            Xem tất cả danh mục &rarr;
                        </a>
                        <span class="badge bg-success-subtle text-success">Hoạt động</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card Users -->
        <div class="col-md-6 col-lg-6">
            <div class="card border-0 shadow-sm rounded-3 h-100">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase small fw-bold">Tổng số người dùng</span>
                            <h2 class="fw-bold text-primary mt-2 mb-0">${totalUsers}</h2>
                        </div>
                        <div class="p-3 bg-primary-subtle text-primary rounded-circle">
                            <span class="fw-bold fs-4">U</span>
                        </div>
                    </div>
                    <div class="mt-3 pt-3 border-top d-flex justify-content-between align-items-center">
                        <a href="<c:url value='/admin/users'/>" class="text-decoration-none small fw-semibold text-primary">
                            Xem danh sách người dùng &rarr;
                        </a>
                        <span class="badge bg-success-subtle text-success">Phân quyền</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Overview Tables -->
    <div class="row g-4">
        <!-- Recent Categories -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-bottom">
                    <h6 class="fw-bold mb-0 text-dark">Danh mục sản phẩm gần đây</h6>
                    <a href="<c:url value='/admin/categories'/>" class="small text-decoration-none">Quản lý</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>ID</th>
                                    <th>Ảnh</th>
                                    <th>Tên danh mục</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${categories}" begin="0" end="4">
                                    <tr>
                                        <td>${c.categoryId}</td>
                                        <td>
                                            <img src="<c:url value='/image?fname=${c.images}'/>" width="32" height="32" class="rounded object-fit-cover border" alt="Ảnh" />
                                        </td>
                                        <td class="fw-semibold">${c.categoryName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 1}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Tạm khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Users -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-bottom">
                    <h6 class="fw-bold mb-0 text-dark">Người dùng hệ thống gần đây</h6>
                    <a href="<c:url value='/admin/users'/>" class="small text-decoration-none">Quản lý</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>Avatar</th>
                                    <th>Tài khoản</th>
                                    <th>Họ và tên</th>
                                    <th>Vai trò</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${users}" begin="0" end="4">
                                    <tr>
                                        <td>
                                            <img src="<c:url value='/image?fname=${u.images}'/>" width="32" height="32" class="rounded-circle object-fit-cover border" alt="Avatar" />
                                        </td>
                                        <td class="fw-semibold">${u.username}</td>
                                        <td>${u.fullname}</td>
                                        <td>
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">${u.role}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

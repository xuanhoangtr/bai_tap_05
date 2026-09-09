<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Người dùng - Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Quản lý Người dùng</h3>
            <p class="text-muted small mb-0">Quản lý danh sách tài khoản, phân quyền và trạng thái người dùng trong hệ thống</p>
        </div>
        <div>
            <a href="<c:url value='/admin/users/add'/>" class="btn btn-primary">
                Thêm người dùng mới
            </a>
        </div>
    </div>

    <!-- Search & Filter Card -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="<c:url value='/admin/users'/>" method="GET" class="row g-2 align-items-center">
                <div class="col-md-9">
                    <div class="input-group">
                        <span class="input-group-text bg-white">Tìm kiếm</span>
                        <input type="text" name="keyword" class="form-control" 
                               placeholder="Tìm theo tên đăng nhập, họ tên, email hoặc số điện thoại..." 
                               value="${keyword}">
                    </div>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-fill">Tìm kiếm</button>
                    <a href="<c:url value='/admin/users'/>" class="btn btn-outline-secondary">Làm mới</a>
                </div>
            </form>
        </div>
    </div>

    <!-- User Table Card -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h6 class="mb-0 fw-bold">Tổng số tài khoản: <span class="badge bg-primary">${totalItems}</span></h6>
            <c:if test="${not empty keyword}">
                <small class="text-muted">Kết quả tìm kiếm cho từ khóa: "<strong>${keyword}</strong>"</small>
            </c:if>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" style="width: 70px;" class="text-center">ID</th>
                            <th scope="col" style="width: 80px;" class="text-center">Avatar</th>
                            <th scope="col">Tài khoản &amp; Họ tên</th>
                            <th scope="col">Liên hệ (Email &amp; SĐT)</th>
                            <th scope="col" style="width: 130px;" class="text-center">Vai trò</th>
                            <th scope="col" style="width: 140px;" class="text-center">Trạng thái</th>
                            <th scope="col" style="width: 180px;" class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty userPage.content}">
                                <c:forEach var="item" items="${userPage.content}">
                                    <tr>
                                        <td class="text-center fw-semibold">${item.id}</td>
                                        <td class="text-center">
                                            <img src="<c:url value='/image?fname=${item.images}'/>" 
                                                 alt="${item.username}" 
                                                 class="rounded-circle border" 
                                                 style="width: 45px; height: 45px; object-fit: cover;">
                                        </td>
                                        <td>
                                            <div class="fw-bold text-dark">${item.username}</div>
                                            <div class="small text-muted">${item.fullname}</div>
                                        </td>
                                        <td>
                                            <div class="small">${item.email}</div>
                                            <div class="small text-muted">${item.phone}</div>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.role == 'ADMIN'}">
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1">
                                                        ADMIN
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info-subtle text-info-emphasis border border-info-subtle px-3 py-1">
                                                        USER
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.status == 1}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-1">
                                                        Hoạt động
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-3 py-1">
                                                        Đã khóa
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center align-items-center gap-1">
                                                <a href="<c:url value='/admin/users/edit/${item.id}'/>" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    Sửa
                                                </a>
                                                <form action="<c:url value='/admin/users/delete/${item.id}'/>" 
                                                      method="POST" 
                                                      class="d-inline mb-0" 
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng: ${item.username}?');">
                                                    <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}" />
                                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                                        Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
                                        Không tìm thấy người dùng nào phù hợp.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white d-flex justify-content-between align-items-center py-3">
                <small class="text-muted">Trang ${currentPage} / ${totalPages}</small>
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/users?keyword=${keyword}&page=1'/>">Đầu</a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/users?keyword=${keyword}&page=${currentPage - 1}'/>">Trước</a>
                        </li>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/users?keyword=${keyword}&page=${i}'/>">${i}</a>
                                </li>
                            </c:if>
                        </c:forEach>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/users?keyword=${keyword}&page=${currentPage + 1}'/>">Sau</a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/users?keyword=${keyword}&page=${totalPages}'/>">Cuối</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</body>
</html>

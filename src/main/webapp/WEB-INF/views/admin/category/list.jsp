<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Danh mục - Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Quản lý Danh mục</h3>
            <p class="text-muted small mb-0">Danh sách các danh mục sản phẩm trong hệ thống</p>
        </div>
        <div>
            <a href="<c:url value='/admin/categories/add'/>" class="btn btn-primary">
                Thêm danh mục mới
            </a>
        </div>
    </div>

    <!-- Search & Filter Form -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="<c:url value='/admin/categories'/>" method="GET" class="row g-2 align-items-center">
                <div class="col-md-9">
                    <div class="input-group">
                        <span class="input-group-text bg-white">Tìm kiếm</span>
                        <input type="text" name="keyword" class="form-control" 
                               placeholder="Nhập tên danh mục cần tìm..." 
                               value="${keyword}">
                    </div>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-fill">Tìm kiếm</button>
                    <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary">Làm mới</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Category Table Card -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h6 class="mb-0 fw-bold">Tổng số danh mục: <span class="badge bg-primary">${totalItems}</span></h6>
            <c:if test="${not empty keyword}">
                <small class="text-muted">Kết quả tìm kiếm cho từ khóa: "<strong>${keyword}</strong>"</small>
            </c:if>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" style="width: 80px;" class="text-center">ID</th>
                            <th scope="col" style="width: 120px;" class="text-center">Hình ảnh</th>
                            <th scope="col">Tên danh mục</th>
                            <th scope="col" style="width: 160px;" class="text-center">Trạng thái</th>
                            <th scope="col" style="width: 200px;" class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty categoryPage.content}">
                                <c:forEach var="item" items="${categoryPage.content}">
                                    <tr>
                                        <td class="text-center fw-semibold">${item.categoryId}</td>
                                        <td class="text-center">
                                            <img src="<c:url value='/image?fname=${item.images}'/>" 
                                                 alt="${item.categoryName}" 
                                                 class="rounded border" 
                                                 style="width: 50px; height: 50px; object-fit: cover;">
                                        </td>
                                        <td>
                                            <span class="fw-bold">${item.categoryName}</span>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.status == 1}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2">
                                                        Hoạt động
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-3 py-2">
                                                        Tạm khóa
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center align-items-center gap-1">
                                                <a href="<c:url value='/admin/categories/edit/${item.categoryId}'/>" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    Sửa
                                                </a>
                                                <form action="<c:url value='/admin/categories/delete/${item.categoryId}'/>" 
                                                      method="POST" 
                                                      class="d-inline mb-0" 
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa danh mục: ${item.categoryName}?');">
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
                                    <td colspan="5" class="text-center py-4 text-muted">
                                        Không tìm thấy dữ liệu danh mục nào phù hợp.
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
                            <a class="page-link" href="<c:url value='/admin/categories?keyword=${keyword}&page=1'/>">Đầu</a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/categories?keyword=${keyword}&page=${currentPage - 1}'/>">Trước</a>
                        </li>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="<c:url value='/admin/categories?keyword=${keyword}&page=${i}'/>">${i}</a>
                                </li>
                            </c:if>
                        </c:forEach>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/categories?keyword=${keyword}&page=${currentPage + 1}'/>">Sau</a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="<c:url value='/admin/categories?keyword=${keyword}&page=${totalPages}'/>">Cuối</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</body>
</html>

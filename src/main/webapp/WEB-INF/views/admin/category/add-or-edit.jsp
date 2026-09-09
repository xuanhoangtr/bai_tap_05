<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${isEdit ? 'Chỉnh sửa Danh mục' : 'Thêm mới Danh mục'} - Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">${isEdit ? 'Chỉnh sửa Danh mục' : 'Thêm mới Danh mục'}</h3>
            <p class="text-muted small mb-0">${isEdit ? 'Cập nhật thông tin danh mục sản phẩm hiện có' : 'Tạo mới một danh mục sản phẩm vào hệ thống'}</p>
        </div>
        <div>
            <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary">
                Quay lại danh sách
            </a>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="card-title mb-0 fw-bold text-primary">
                        ${isEdit ? 'Thông tin Danh mục #' : 'Thông tin Danh mục Mới'}${isEdit ? category.categoryId : ''}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form:form action="${pageContext.request.contextPath}/admin/categories/save" 
                               method="POST" 
                               modelAttribute="category" 
                               enctype="multipart/form-data">

                        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}" />
                        <input type="hidden" name="isEdit" value="${isEdit}" />
                        <c:if test="${isEdit}">
                            <form:hidden path="categoryId" />
                            <form:hidden path="images" />
                        </c:if>

                        <!-- Category Name -->
                        <div class="mb-3">
                            <label for="categoryName" class="form-label fw-semibold">
                                Tên danh mục <span class="text-danger">*</span>
                            </label>
                            <form:input path="categoryName" 
                                        id="categoryName" 
                                        cssClass="form-control" 
                                        placeholder="Ví dụ: Điện thoại, Laptop, Đồng hồ..." 
                                        required="required" />
                            <form:errors path="categoryName" cssClass="invalid-feedback d-block text-danger small mt-1" />
                        </div>

                        <!-- Status -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold d-block">Trạng thái hoạt động</label>
                            <div class="form-check form-check-inline">
                                <form:radiobutton path="status" value="1" id="statusActive" cssClass="form-check-input"/>
                                <label class="form-check-label text-success fw-medium" for="statusActive">Hoạt động</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <form:radiobutton path="status" value="0" id="statusInactive" cssClass="form-check-input"/>
                                <label class="form-check-label text-secondary fw-medium" for="statusInactive">Tạm khóa</label>
                            </div>
                            <form:errors path="status" cssClass="invalid-feedback d-block text-danger small mt-1" />
                        </div>

                        <!-- Image Upload & Preview -->
                        <div class="mb-4">
                            <label for="imageFile" class="form-label fw-semibold">Hình ảnh đại diện</label>
                                <input type="file" 
                                   name="imageFile" 
                                   id="imageFile" 
                                   class="form-control" 
                                   accept="image/*" 
                                       onchange="previewImage(this)" />
                                <form:errors path="images" cssClass="invalid-feedback d-block text-danger small mt-1" />
                            <div class="form-text">Định dạng hỗ trợ: JPG, PNG, GIF, WEBP. Dung lượng tối đa 10MB.</div>

                            <div class="mt-3 text-center p-3 border rounded bg-light" style="max-width: 200px;">
                                <div class="small text-muted mb-2">Xem trước hình ảnh:</div>
                                <c:choose>
                                    <c:when test="${not empty category.images}">
                                        <img id="imgPreview" 
                                             src="<c:url value='/image?fname=${category.images}'/>" 
                                             alt="Ảnh danh mục" 
                                             class="rounded border img-fluid" 
                                             style="max-height: 140px; object-fit: cover;" />
                                    </c:when>
                                    <c:otherwise>
                                        <img id="imgPreview" 
                                             src="<c:url value='/image?fname=avatar.png'/>" 
                                             alt="Ảnh danh mục" 
                                             class="rounded border img-fluid" 
                                             style="max-height: 140px; object-fit: cover;" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Form Action Buttons -->
                        <div class="d-flex gap-2 pt-3 border-top">
                            <button type="submit" class="btn btn-primary px-4">
                                ${isEdit ? 'Cập nhật danh mục' : 'Thêm mới danh mục'}
                            </button>
                            <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary">
                                Hủy bỏ
                            </a>
                        </div>

                    </form:form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('imgPreview').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>

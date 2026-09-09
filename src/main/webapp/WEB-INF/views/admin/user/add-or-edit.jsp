<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>${isEdit ? 'Chỉnh sửa Người dùng' : 'Thêm mới Người dùng'} - Admin</title>
</head>
<body>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">${isEdit ? 'Chỉnh sửa Người dùng' : 'Thêm mới Người dùng'}</h3>
            <p class="text-muted small mb-0">${isEdit ? 'Cập nhật thông tin tài khoản người dùng' : 'Tạo mới một tài khoản người dùng vào hệ thống'}</p>
        </div>
        <div>
            <a href="<c:url value='/admin/users'/>" class="btn btn-outline-secondary">
                Quay lại danh sách
            </a>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="card-title mb-0 fw-bold text-primary">
                        ${isEdit ? 'Thông tin Tài khoản #' : 'Tạo Tài khoản Mới'}${isEdit ? user.id : ''}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form:form action="${pageContext.request.contextPath}/admin/users/save" 
                               method="POST" 
                               modelAttribute="user" 
                               enctype="multipart/form-data">

                        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}" />
                        <input type="hidden" name="isEdit" value="${isEdit}" />
                        <c:if test="${isEdit}">
                            <form:hidden path="id" />
                            <form:hidden path="images" />
                        </c:if>

                        <div class="row g-3">
                            <!-- Username -->
                            <div class="col-md-6">
                                <label for="username" class="form-label fw-semibold">
                                    Tên đăng nhập <span class="text-danger">*</span>
                                </label>
                                <form:input path="username" 
                                            id="username" 
                                            cssClass="form-control" 
                                            placeholder="Nhập tên đăng nhập..." 
                                            required="required" />
                                <form:errors path="username" cssClass="invalid-feedback d-block text-danger small mt-1" />
                            </div>

                            <!-- Password -->
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-semibold">
                                    Mật khẩu <c:if test="${isEdit}"><span class="text-muted fw-normal">(Để trống nếu giữ nguyên)</span></c:if><c:if test="${!isEdit}"><span class="text-danger">*</span></c:if>
                                </label>
                                <form:password path="password" 
                                               id="password" 
                                               cssClass="form-control" 
                                               placeholder="${isEdit ? 'Nhập mật khẩu mới nếu muốn đổi...' : 'Nhập mật khẩu...'}" 
                                               showPassword="true" />
                                <form:errors path="password" cssClass="invalid-feedback d-block text-danger small mt-1" />
                            </div>

                            <!-- Fullname -->
                            <div class="col-md-6">
                                <label for="fullname" class="form-label fw-semibold">
                                    Họ và tên <span class="text-danger">*</span>
                                </label>
                                <form:input path="fullname" 
                                            id="fullname" 
                                            cssClass="form-control" 
                                            placeholder="Ví dụ: Nguyễn Văn A..." 
                                            required="required" />
                                <form:errors path="fullname" cssClass="invalid-feedback d-block text-danger small mt-1" />
                            </div>

                            <!-- Email -->
                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold">
                                    Địa chỉ Email <span class="text-danger">*</span>
                                </label>
                                <form:input path="email" 
                                            type="email" 
                                            id="email" 
                                            cssClass="form-control" 
                                            placeholder="example@gmail.com" 
                                            required="required" />
                                <form:errors path="email" cssClass="invalid-feedback d-block text-danger small mt-1" />
                            </div>

                            <!-- Phone -->
                            <div class="col-md-6">
                                <label for="phone" class="form-label fw-semibold">
                                    Số điện thoại <span class="text-danger">*</span>
                                </label>
                                <form:input path="phone" 
                                            id="phone" 
                                            cssClass="form-control" 
                                            placeholder="Ví dụ: 0912345678" 
                                            required="required" />
                                <form:errors path="phone" cssClass="invalid-feedback d-block text-danger small mt-1" />
                            </div>

                            <!-- Role -->
                            <div class="col-md-6">
                                <label for="role" class="form-label fw-semibold">Vai trò (Phân quyền)</label>
                                <form:select path="role" id="role" cssClass="form-select">
                                    <form:option value="USER">USER (Người dùng thông thường)</form:option>
                                    <form:option value="ADMIN">ADMIN (Quản trị viên hệ thống)</form:option>
                                </form:select>
                            </div>

                            <!-- Status -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold d-block">Trạng thái tài khoản</label>
                                <div class="form-check form-check-inline mt-1">
                                    <form:radiobutton path="status" value="1" id="userStatusActive" cssClass="form-check-input"/>
                                    <label class="form-check-label text-success fw-medium" for="userStatusActive">Hoạt động</label>
                                </div>
                                <div class="form-check form-check-inline mt-1">
                                    <form:radiobutton path="status" value="0" id="userStatusInactive" cssClass="form-check-input"/>
                                    <label class="form-check-label text-danger fw-medium" for="userStatusInactive">Khóa tài khoản</label>
                                </div>
                            </div>

                            <!-- Avatar Upload & Preview -->
                            <div class="col-md-12">
                                <label for="imageFile" class="form-label fw-semibold">Ảnh đại diện (Avatar)</label>
                                <input type="file" 
                                       name="imageFile" 
                                       id="imageFile" 
                                       class="form-control" 
                                       accept="image/*" 
                                       onchange="previewAvatar(this)" />
                                <form:errors path="images" cssClass="invalid-feedback d-block text-danger small mt-1" />
                                <div class="form-text">Định dạng hỗ trợ: JPG, PNG, GIF, WEBP. Dung lượng tối đa 10MB.</div>

                                <div class="mt-3 p-3 border rounded bg-light d-inline-block text-center">
                                    <div class="small text-muted mb-2">Xem trước Avatar:</div>
                                    <c:choose>
                                        <c:when test="${not empty user.images}">
                                            <img id="avatarPreview" 
                                                 src="<c:url value='/image?fname=${user.images}'/>" 
                                                 alt="Avatar" 
                                                 class="rounded-circle border" 
                                                 style="width: 80px; height: 80px; object-fit: cover;" />
                                        </c:when>
                                        <c:otherwise>
                                            <img id="avatarPreview" 
                                                 src="<c:url value='/image?fname=avatar.png'/>" 
                                                 alt="Avatar" 
                                                 class="rounded-circle border" 
                                                 style="width: 80px; height: 80px; object-fit: cover;" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2 pt-4 mt-3 border-top">
                            <button type="submit" class="btn btn-primary px-4">
                                ${isEdit ? 'Cập nhật tài khoản' : 'Thêm mới người dùng'}
                            </button>
                            <a href="<c:url value='/admin/users'/>" class="btn btn-outline-secondary">
                                Hủy bỏ
                            </a>
                        </div>

                    </form:form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatarPreview').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>

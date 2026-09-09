package vn.iotstar.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler({MaxUploadSizeExceededException.class, MultipartException.class})
    public String handleMultipartException(HttpServletRequest request, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("error", "Không thể tải ảnh lên. Mỗi ảnh tối đa 10MB và biểu mẫu gửi không hợp lệ.");
        return "redirect:" + getAdminListPath(request.getRequestURI());
    }

    private String getAdminListPath(String requestUri) {
        return requestUri.contains("/admin/categories") ? "/admin/categories" : "/admin/users";
    }
}

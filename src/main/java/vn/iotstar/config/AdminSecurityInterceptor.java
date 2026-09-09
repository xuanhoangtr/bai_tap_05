package vn.iotstar.config;

import java.util.UUID;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;

@Component
public class AdminSecurityInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(true);

        // Dam bao luon co CSRF Token trong Session cho moi phien lam viec
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }

        User adminUser = (User) session.getAttribute("adminUser");

        // 1. Kiem tra xac thuc: Chua dang nhap
        if (adminUser == null) {
            session.setAttribute("error", "Vui lòng đăng nhập tài khoản Quản trị viên (Admin) để tiếp tục.");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        // 2. Kiem tra phan quyen: Role khong phai ADMIN
        if (!"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            session.removeAttribute("adminUser"); // Xoa session adminUser de tranh vong lap redirect
            session.setAttribute("error", "Tài khoản của bạn không có quyền truy cập vào khu vực Quản trị Admin.");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        // 3. Kiem tra CSRF Token doi voi cac request POST thay doi du lieu
        if (requiresCsrf(request.getMethod())) {
            String requestCsrf = request.getParameter("_csrf");
            String sessionCsrf = (String) session.getAttribute("csrfToken");
            if (sessionCsrf == null || requestCsrf == null || !sessionCsrf.equals(requestCsrf)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Yêu cầu bị từ chối: CSRF Token không hợp lệ hoặc đã hết hạn.");
                return false;
            }
        }

        return true;
    }

    private boolean requiresCsrf(String method) {
        return "POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method)
                || "PATCH".equalsIgnoreCase(method) || "DELETE".equalsIgnoreCase(method);
    }
}

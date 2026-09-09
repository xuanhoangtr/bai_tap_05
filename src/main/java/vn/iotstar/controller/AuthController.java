package vn.iotstar.controller;

import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;

@Controller
public class AuthController {

    @Autowired
    private IUserService userService;

    @GetMapping({"/", "/home"})
    public String index(HttpSession session) {
        User adminUser = (User) session.getAttribute("adminUser");
        if (adminUser != null && "ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            return "redirect:/admin/dashboard";
        }
        if (adminUser != null) {
            session.removeAttribute("adminUser");
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String showLoginForm(HttpSession session, Model model) {
        // Dam bao co CSRF Token
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }

        User adminUser = (User) session.getAttribute("adminUser");
        if (adminUser != null && "ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            return "redirect:/admin/dashboard";
        }
        if (adminUser != null) {
            session.removeAttribute("adminUser");
        }

        // Lay thong bao loi/thanh cong tu Session va xoa ngay sau do de tranh luu vet
        if (session.getAttribute("error") != null) {
            model.addAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }
        if (session.getAttribute("message") != null) {
            model.addAttribute("message", session.getAttribute("message"));
            session.removeAttribute("message");
        }

        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("username") String username,
                               @RequestParam("password") String password,
                               @RequestParam(value = "_csrf", required = false) String csrf,
                               HttpSession session,
                               Model model) {
        // Kiem tra CSRF Token
        String sessionCsrf = (String) session.getAttribute("csrfToken");
        if (sessionCsrf == null || csrf == null || !sessionCsrf.equals(csrf)) {
            model.addAttribute("error", "Phiên làm việc hết hạn (CSRF Token mismatch). Vui lòng thử lại.");
            return "login";
        }

        if (username == null || username.trim().isEmpty()) {
            model.addAttribute("error", "Tên đăng nhập không được để trống.");
            return "login";
        }
        if (password == null || password.trim().isEmpty()) {
            model.addAttribute("error", "Mật khẩu không được để trống.");
            model.addAttribute("username", username);
            return "login";
        }

        User user = userService.login(username.trim(), password.trim());
        if (user == null) {
            model.addAttribute("error", "Tài khoản hoặc mật khẩu không chính xác.");
            model.addAttribute("username", username);
            return "login";
        }

        if (user.getStatus() != 1) {
            model.addAttribute("error", "Tài khoản đang bị khóa hoặc chưa được kích hoạt.");
            model.addAttribute("username", username);
            return "login";
        }

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            model.addAttribute("error", "Tài khoản của bạn (quyền " + user.getRole() + ") không có quyền truy cập vào khu vực Quản trị Admin.");
            model.addAttribute("username", username);
            return "login";
        }

        // Luu user vao session
        session.setAttribute("adminUser", user);
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("message", "Đã đăng xuất khỏi hệ thống quản trị thành công.");
        return "redirect:/login";
    }
}

package vn.iotstar.controller.admin;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import vn.iotstar.entity.User;
import vn.iotstar.service.ImageStorageService;
import vn.iotstar.service.InvalidImageFileException;
import vn.iotstar.service.IUserService;

@Controller
@RequestMapping("/admin/users")
public class UserAdminController {

    public static final int PAGE_SIZE = 6;

    @Autowired
    private IUserService userService;

    @Autowired
    private ImageStorageService imageStorageService;

    @GetMapping({"", "/"})
    public String listUsers(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", defaultValue = "1") String page,
            Model model) {

        // Gioi han phan trang co dinh 6 muc/trang theo yeu cau de bai
        int currentPage = parsePage(page);
        Pageable pageable = PageRequest.of(currentPage - 1, PAGE_SIZE, Sort.by("id").descending());
        Page<User> userPage = userService.search(keyword, pageable);

        model.addAttribute("userPage", userPage);
        model.addAttribute("keyword", keyword != null ? keyword.trim() : "");
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", Math.max(1, userPage.getTotalPages()));
        model.addAttribute("totalItems", userPage.getTotalElements());

        return "admin/user/list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        User user = new User();
        user.setRole("USER");
        user.setStatus(1);
        model.addAttribute("user", user);
        model.addAttribute("isEdit", false);
        return "admin/user/add-or-edit";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, RedirectAttributes redirectAttributes) {
        Optional<User> opt = userService.findById(id);
        if (opt.isPresent()) {
            model.addAttribute("user", opt.get());
            model.addAttribute("isEdit", true);
            return "admin/user/add-or-edit";
        }
        redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng có ID: " + id);
        return "redirect:/admin/users";
    }

    @PostMapping("/save")
    public String saveUser(
            @Valid @ModelAttribute("user") User user,
            BindingResult result,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "isEdit", defaultValue = "false") boolean isEdit,
            Model model,
            RedirectAttributes redirectAttributes) {

        // Neu dang Edit: kiem tra neu co nhap mat khau moi thi validate do dai, neu khong thi giu mat khau cu
        if (isEdit) {
            Optional<User> oldUserOpt = userService.findById(user.getId());
            if (oldUserOpt.isPresent()) {
                if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                    user.setPassword(oldUserOpt.get().getPassword());
                } else if (user.getPassword().trim().length() < 3) {
                    result.rejectValue("password", "error.password", "Mật khẩu mới phải có từ 3 đến 100 ký tự.");
                    model.addAttribute("isEdit", isEdit);
                    return "admin/user/add-or-edit";
                }
            }
        } else {
            if (user.getPassword() == null || user.getPassword().trim().length() < 3) {
                result.rejectValue("password", "error.password", "Mật khẩu phải có từ 3 đến 100 ký tự.");
                model.addAttribute("isEdit", isEdit);
                return "admin/user/add-or-edit";
            }
        }

        // 1. Kiem tra validation Bean
        if (result.hasFieldErrors("username") || result.hasFieldErrors("email") ||
            result.hasFieldErrors("fullname") || result.hasFieldErrors("phone")) {
            model.addAttribute("isEdit", isEdit);
            return "admin/user/add-or-edit";
        }

        // 2. Kiem tra trung lap Username (khong phan biet hoa thuong)
        Optional<User> existingUsername = userService.findByUsernameIgnoreCase(user.getUsername().trim());
        if (existingUsername.isPresent() && (!isEdit || existingUsername.get().getId() != user.getId())) {
            result.rejectValue("username", "error.user", "Tên đăng nhập này đã tồn tại trong hệ thống (không phân biệt hoa thường).");
            model.addAttribute("isEdit", isEdit);
            return "admin/user/add-or-edit";
        }

        // 3. Kiem tra trung lap Email (khong phan biet hoa thuong)
        Optional<User> existingEmail = userService.findByEmailIgnoreCase(user.getEmail().trim());
        if (existingEmail.isPresent() && (!isEdit || existingEmail.get().getId() != user.getId())) {
            result.rejectValue("email", "error.user", "Địa chỉ email này đã được sử dụng (không phân biệt hoa thường).");
            model.addAttribute("isEdit", isEdit);
            return "admin/user/add-or-edit";
        }

        // 4. Xu ly upload Avatar
        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                user.setImages(imageStorageService.store(imageFile, "user"));
            } else if (user.getImages() == null || user.getImages().trim().isEmpty()) {
                user.setImages("avatar.png");
            }
        } catch (InvalidImageFileException e) {
            result.rejectValue("images", "error.image", e.getMessage());
            model.addAttribute("isEdit", isEdit);
            return "admin/user/add-or-edit";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi tải lên ảnh avatar.");
            model.addAttribute("isEdit", isEdit);
            return "admin/user/add-or-edit";
        }

        // 5. Luu vao database qua JPA kem bat ngoai le trung lap (Race condition)
        try {
            userService.save(user);
        } catch (DataIntegrityViolationException e) {
            result.rejectValue("username", "error.user", "Tên đăng nhập hoặc email đã tồn tại trong cơ sở dữ liệu.");
            model.addAttribute("isEdit", isEdit);
            return "admin/user/add-or-edit";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi lưu tài khoản người dùng: " + e.getMessage());
            model.addAttribute("isEdit", isEdit);
            return "admin/user/add-or-edit";
        }

        if (isEdit) {
            redirectAttributes.addFlashAttribute("message", "Cập nhật tài khoản '" + user.getUsername() + "' thành công!");
        } else {
            redirectAttributes.addFlashAttribute("message", "Thêm mới người dùng '" + user.getUsername() + "' thành công!");
        }

        return "redirect:/admin/users";
    }

    @PostMapping("/delete/{id}")
    public String deleteUser(
            @PathVariable("id") Integer id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User currentUser = (User) session.getAttribute("adminUser");
        if (currentUser != null && currentUser.getId() == id) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa tài khoản Admin đang đăng nhập hiện tại!");
            return "redirect:/admin/users";
        }

        try {
            Optional<User> opt = userService.findById(id);
            if (opt.isPresent()) {
                userService.deleteById(id);
                redirectAttributes.addFlashAttribute("message", "Đã xóa thành công người dùng: " + opt.get().getUsername());
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng cần xóa (ID: " + id + ")");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa người dùng: " + e.getMessage());
        }

        return "redirect:/admin/users";
    }

    private int parsePage(String page) {
        try {
            return Math.max(1, Integer.parseInt(page));
        } catch (NumberFormatException e) {
            return 1;
        }
    }
}

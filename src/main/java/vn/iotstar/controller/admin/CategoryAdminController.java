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
import jakarta.validation.Valid;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.ImageStorageService;
import vn.iotstar.service.InvalidImageFileException;

@Controller
@RequestMapping("/admin/categories")
public class CategoryAdminController {

    public static final int PAGE_SIZE = 6;

    @Autowired
    private ICategoryService categoryService;

    @Autowired
    private ImageStorageService imageStorageService;

    @GetMapping({"", "/"})
    public String listCategories(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", defaultValue = "1") String page,
            Model model) {

        // Gioi han phan trang co dinh 6 muc/trang theo yeu cau de bai
        int currentPage = parsePage(page);
        Pageable pageable = PageRequest.of(currentPage - 1, PAGE_SIZE, Sort.by("categoryId").descending());
        Page<Category> categoryPage = categoryService.search(keyword, pageable);

        model.addAttribute("categoryPage", categoryPage);
        model.addAttribute("keyword", keyword != null ? keyword.trim() : "");
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", Math.max(1, categoryPage.getTotalPages()));
        model.addAttribute("totalItems", categoryPage.getTotalElements());

        return "admin/category/list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("category", new Category());
        model.addAttribute("isEdit", false);
        return "admin/category/add-or-edit";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Category> opt = categoryService.findById(id);
        if (opt.isPresent()) {
            model.addAttribute("category", opt.get());
            model.addAttribute("isEdit", true);
            return "admin/category/add-or-edit";
        }
        redirectAttributes.addFlashAttribute("error", "Không tìm thấy danh mục có ID: " + id);
        return "redirect:/admin/categories";
    }

    @PostMapping("/save")
    public String saveCategory(
            @Valid @ModelAttribute("category") Category category,
            BindingResult result,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "isEdit", defaultValue = "false") boolean isEdit,
            Model model,
            RedirectAttributes redirectAttributes) {

        // 1. Kiểm tra Bean Validation
        if (result.hasErrors()) {
            model.addAttribute("isEdit", isEdit);
            return "admin/category/add-or-edit";
        }

        // 2. Kiểm tra trùng lặp tên danh mục (không phân biệt hoa thường)
        Optional<Category> existing = categoryService.findByCategoryNameIgnoreCase(category.getCategoryName().trim());
        if (existing.isPresent() && (!isEdit || existing.get().getCategoryId() != category.getCategoryId())) {
            result.rejectValue("categoryName", "error.category", "Tên danh mục này đã tồn tại trong hệ thống (không phân biệt hoa thường).");
            model.addAttribute("isEdit", isEdit);
            return "admin/category/add-or-edit";
        }

        // 3. Xử lý tải lên file ảnh đại diện
        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                category.setImages(imageStorageService.store(imageFile, "cat"));
            } else if (category.getImages() == null || category.getImages().trim().isEmpty()) {
                category.setImages("avatar.png");
            }
        } catch (InvalidImageFileException e) {
            result.rejectValue("images", "error.image", e.getMessage());
            model.addAttribute("isEdit", isEdit);
            return "admin/category/add-or-edit";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi trong quá trình tải lên ảnh.");
            model.addAttribute("isEdit", isEdit);
            return "admin/category/add-or-edit";
        }

        // 4. Lưu vào Database qua Spring Data JPA kèm bắt ngoại lệ trùng lặp (Race condition)
        try {
            categoryService.save(category);
        } catch (DataIntegrityViolationException e) {
            result.rejectValue("categoryName", "error.category", "Tên danh mục này đã tồn tại trong cơ sở dữ liệu.");
            model.addAttribute("isEdit", isEdit);
            return "admin/category/add-or-edit";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi lưu dữ liệu danh mục: " + e.getMessage());
            model.addAttribute("isEdit", isEdit);
            return "admin/category/add-or-edit";
        }

        if (isEdit) {
            redirectAttributes.addFlashAttribute("message", "Cập nhật danh mục '" + category.getCategoryName() + "' thành công!");
        } else {
            redirectAttributes.addFlashAttribute("message", "Thêm mới danh mục '" + category.getCategoryName() + "' thành công!");
        }

        return "redirect:/admin/categories";
    }

    @PostMapping("/delete/{id}")
    public String deleteCategory(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            Optional<Category> opt = categoryService.findById(id);
            if (opt.isPresent()) {
                categoryService.deleteById(id);
                redirectAttributes.addFlashAttribute("message", "Đã xóa thành công danh mục: " + opt.get().getCategoryName());
            } else {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy danh mục cần xóa (ID: " + id + ")");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa danh mục vì đang có ràng buộc dữ liệu hoặc lỗi hệ thống.");
        }
        return "redirect:/admin/categories";
    }

    private int parsePage(String page) {
        try {
            return Math.max(1, Integer.parseInt(page));
        } catch (NumberFormatException e) {
            return 1;
        }
    }
}

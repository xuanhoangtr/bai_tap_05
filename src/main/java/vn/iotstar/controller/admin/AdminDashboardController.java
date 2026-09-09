package vn.iotstar.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IUserService;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    @Autowired
    private ICategoryService categoryService;

    @Autowired
    private IUserService userService;

    @GetMapping({"", "/", "/home", "/dashboard"})
    public String dashboard(Model model, HttpSession session) {
        long totalCategories = categoryService.count();
        long totalUsers = userService.count();

        model.addAttribute("totalCategories", totalCategories);
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("users", userService.findAll());

        return "admin/dashboard";
    }
}

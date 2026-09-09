package vn.iotstar.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.repository.CategoryRepository;
import vn.iotstar.repository.UserRepository;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        // 1. Tu dong tao cac chi muc Case-Insensitive Unique Index trong PostgreSQL neu chua ton tai
        try {
            jdbcTemplate.execute("CREATE UNIQUE INDEX IF NOT EXISTS uk_categories_name_lower ON categories (LOWER(TRIM(categoryname)));");
            jdbcTemplate.execute("CREATE UNIQUE INDEX IF NOT EXISTS uk_users_username_lower ON users (LOWER(TRIM(username)));");
            jdbcTemplate.execute("CREATE UNIQUE INDEX IF NOT EXISTS uk_users_email_lower ON users (LOWER(TRIM(email)));");
            System.out.println("-> Da dong bo cac chi muc Case-Insensitive Unique Index trong PostgreSQL thanh cong.");
        } catch (Exception e) {
            throw new IllegalStateException("Không thể tạo unique index không phân biệt hoa thường. Hãy xử lý dữ liệu trùng trong PostgreSQL trước khi chạy ứng dụng.", e);
        }

        // 2. Khoi tao User Admin mac dinh neu chua ton tai hoac cap nhat vai tro ADMIN
        userRepository.findByUsernameIgnoreCase("xuan").ifPresentOrElse(
            xuan -> {
                if (!"ADMIN".equalsIgnoreCase(xuan.getRole())) {
                    xuan.setRole("ADMIN");
                    userRepository.save(xuan);
                }
            },
            () -> {
                User admin = new User();
                admin.setUsername("xuan");
                admin.setPassword("123");
                admin.setEmail("xuanhoangtr@gmail.com");
                admin.setFullname("Tran Xuan Hoang");
                admin.setPhone("0987654321");
                admin.setImages("avatar.png");
                admin.setRole("ADMIN");
                admin.setStatus(1);
                userRepository.save(admin);
                System.out.println("-> Khoi tao tai khoan Admin mac dinh: xuan / 123 (ADMIN)");
            }
        );

        if (userRepository.findByUsernameIgnoreCase("user1").isEmpty()) {
            User user1 = new User();
            user1.setUsername("user1");
            user1.setPassword("123456");
            user1.setEmail("user1@gmail.com");
            user1.setFullname("Nguyen Van A");
            user1.setPhone("0912345678");
            user1.setImages("avatar.png");
            user1.setRole("USER");
            user1.setStatus(1);
            userRepository.save(user1);
        }

        // 3. Khoi tao Categories mau neu chua co
        if (categoryRepository.count() == 0) {
            categoryRepository.save(new Category(0, "Điện thoại thông minh", "avatar.png", 1));
            categoryRepository.save(new Category(0, "Laptop & Máy tính bảng", "avatar.png", 1));
            categoryRepository.save(new Category(0, "Tai nghe & Âm thanh", "avatar.png", 1));
            categoryRepository.save(new Category(0, "Đồng hồ thông minh", "avatar.png", 1));
            categoryRepository.save(new Category(0, "Phụ kiện & Cáp sạc", "avatar.png", 1));
            System.out.println("-> Khoi tao 5 danh muc mau thanh cong.");
        }
    }
}

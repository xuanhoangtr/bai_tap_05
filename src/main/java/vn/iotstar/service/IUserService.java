package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.User;

public interface IUserService {
    List<User> findAll();
    Page<User> findAll(Pageable pageable);
    Optional<User> findById(Integer id);
    Optional<User> findByUsername(String username);
    Optional<User> findByUsernameIgnoreCase(String username);
    Optional<User> findByEmail(String email);
    Optional<User> findByEmailIgnoreCase(String email);
    Page<User> search(String keyword, Pageable pageable);
    User save(User user);
    void deleteById(Integer id);
    long count();
    User login(String username, String password);
}

package vn.iotstar.repository;

import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    
    @Query("SELECT u FROM User u WHERE " +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :kw, '%')) OR " +
           "LOWER(u.fullname) LIKE LOWER(CONCAT('%', :kw, '%')) OR " +
           "LOWER(u.email) LIKE LOWER(CONCAT('%', :kw, '%')) OR " +
           "u.phone LIKE CONCAT('%', :kw, '%')")
    Page<User> searchUsers(@Param("kw") String keyword, Pageable pageable);

    Optional<User> findByUsernameIgnoreCase(String username);
    Optional<User> findByEmailIgnoreCase(String email);
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsernameAndPassword(String username, String password);
}

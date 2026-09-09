package vn.iotstar.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Category;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {
    Page<Category> findByCategoryNameContainingIgnoreCase(String name, Pageable pageable);
    List<Category> findByCategoryNameContainingIgnoreCase(String name);
    Optional<Category> findByCategoryNameIgnoreCase(String name);
    Optional<Category> findByCategoryName(String name);
}

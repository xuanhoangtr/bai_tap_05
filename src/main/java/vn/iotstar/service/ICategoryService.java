package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.Category;

public interface ICategoryService {
    List<Category> findAll();
    Page<Category> findAll(Pageable pageable);
    Optional<Category> findById(Integer id);
    Optional<Category> findByCategoryName(String name);
    Optional<Category> findByCategoryNameIgnoreCase(String name);
    List<Category> findByCategoryNameContaining(String name);
    Page<Category> search(String keyword, Pageable pageable);
    Category save(Category category);
    void deleteById(Integer id);
    long count();
}

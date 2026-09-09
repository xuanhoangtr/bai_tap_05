package vn.iotstar.entity;

import java.io.Serializable;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "categories", uniqueConstraints = {
    @UniqueConstraint(name = "uk_categories_name", columnNames = {"categoryname"})
})
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "categoryid")
    private int categoryId;

    @NotBlank(message = "Tên danh mục không được để trống.")
    @Size(min = 2, max = 100, message = "Tên danh mục phải có từ 2 đến 100 ký tự.")
    @Column(name = "categoryname", nullable = false, length = 255)
    private String categoryName;

    @Column(name = "images", length = 500)
    private String images;

    @Column(name = "status")
    private int status = 1; // 1: Hoat dong, 0: Khoa / Ngung hoat dong

    public Category() {
    }

    public Category(int categoryId, String categoryName, String images, int status) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.images = images;
        this.status = status;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}

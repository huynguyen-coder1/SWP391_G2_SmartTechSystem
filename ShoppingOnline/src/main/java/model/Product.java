package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {

    private long productId;
    private String productCode;
    private String productName;
    private String description;
    private long priceImport;
    private long price;
    private int quantity;
    private long categoryId;
    private long brandId;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private int status;
    private String images;

    // ⚡ Thêm 2 trường phụ để hiển thị (JOIN từ Category và Brand)
    private String categoryName;
    private String brandName;

    // ===== Constructors =====
    public Product() {
    }

    public Product(long productId, String productCode, String productName, String description,
            long priceImport, long price, int quantity,
            long categoryId, long brandId, Timestamp createdAt, Timestamp updatedAt, int status) {
        this.productId = productId;
        this.productCode = productCode;
        this.productName = productName;
        this.description = description;
        this.priceImport = priceImport;
        this.price = price;
        this.quantity = quantity;
        this.categoryId = categoryId;
        this.brandId = brandId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
    }

    public Product(long productId, String productCode, String productName, String description, long priceImport, long price, int quantity, long categoryId, long brandId, Timestamp createdAt, Timestamp updatedAt, int status, String images, String categoryName, String brandName) {
        this.productId = productId;
        this.productCode = productCode;
        this.productName = productName;
        this.description = description;
        this.priceImport = priceImport;
        this.price = price;
        this.quantity = quantity;
        this.categoryId = categoryId;
        this.brandId = brandId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
        this.images = images;
        this.categoryName = categoryName;
        this.brandName = brandName;
    }

    // ===== Getters and Setters =====
    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long getPriceImport() {
        return priceImport;
    }

    public void setPriceImport(long priceImport) {
        this.priceImport = priceImport;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }

    public long getBrandId() {
        return brandId;
    }

    public void setBrandId(long brandId) {
        this.brandId = brandId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    // ⚡ Getter/Setter cho tên danh mục & thương hiệu
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    // ===== Optional: toString for debugging =====
    @Override
    public String toString() {
        return "Product{"
                + "productId=" + productId
                + ", productCode='" + productCode + '\''
                + ", productName='" + productName + '\''
                + ", description='" + description + '\''
                + ", priceImport=" + priceImport
                + ", price=" + price
                + ", quantity=" + quantity
                + ", categoryId=" + categoryId
                + ", brandId=" + brandId
                + ", categoryName='" + categoryName + '\''
                + ", brandName='" + brandName + '\''
                + ", images='" + images + '\''
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + ", status=" + status
                + '}';
    }
}

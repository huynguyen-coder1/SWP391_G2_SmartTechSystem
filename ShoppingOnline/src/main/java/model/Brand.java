package model;

import java.sql.Timestamp;

public class Brand {
    private long brandId;
    private String brandName;
    private String description;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private int status;

    // ----- Constructors -----
    public Brand() {
    }

    public Brand(long brandID, String brandName, String description, Timestamp createdAt, Timestamp updatedAt, int status) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
    }

    // ----- Getters & Setters -----
    public long getBrandId() {
        return brandId;
    }

    public void setBrandId(long brandId) {
        this.brandId = brandId;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    // ----- toString (optional) -----
    @Override
    public String toString() {
        return "Brand{" +
                "brandID=" + brandId +
                ", brandName='" + brandName + '\'' +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", status=" + status +
                '}';
    }
}
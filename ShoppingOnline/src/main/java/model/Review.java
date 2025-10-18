package model;

import java.util.Date;

/**
 * Model đại diện cho một đánh giá (Review) của người dùng.
 */
public class Review {
    private long id;
    private int userId;
    private long productId;
    private int rating;
    private String comment;
    private Date createdAt;
    private int status;

    private String userName;     // Dùng để hiển thị join với User
    private String productName;  // Dùng để hiển thị join với Product

    public Review() {}

    public Review(long id, int userId, long productId, int rating, String comment, Date createdAt, int status) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.status = status;
    }

    // Getters & Setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}


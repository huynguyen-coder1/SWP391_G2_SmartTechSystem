package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Cart {

    private long id;
    private int userId;
    private double totalMoney;
    private Date createdAt;
    private Date updatedAt;
    private int status;
    private List<CartItem> items;

    public Cart() {
        this.items = new ArrayList<>();
    }

    public Cart(long id, int userId, double totalMoney, Date createdAt, Date updatedAt, int status) {
        this.id = id;
        this.userId = userId;
        this.totalMoney = totalMoney;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
        this.items = new ArrayList<>();
    }

   

    // ================== GETTERS & SETTERS ==================

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getTotalMoney() {
        return totalMoney;
    }

    public void setTotalMoney(double totalMoney) {
        this.totalMoney = totalMoney;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }
}

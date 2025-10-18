package model;

import java.time.LocalDateTime;
import java.util.List;

public class Order {

    private int orderId;
    private int userId;
    private int shipperId;
    private LocalDateTime orderDate;
    private double totalAmount;
    private String status;
    private String address;
    private String note;
    private List<OrderItem> orderItems;

    public Order() {
    }

    public Order(int orderId, int userId, int shipperId, LocalDateTime orderDate,
            double totalAmount, String status, String address, String note) {
        this.orderId = orderId;
        this.userId = userId;
        this.shipperId = shipperId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.address = address;
        this.note = note;
    }

    // --- Getters và Setters ---
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getShipperId() {
        return shipperId;
    }

    public void setShipperId(int shipperId) {
        this.shipperId = shipperId;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }
}

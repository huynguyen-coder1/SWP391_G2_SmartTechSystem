package model;

import java.sql.Timestamp;

public class ShippingHistory {
    private long id;
    private long orderId;
    private long shipperId;
    private int status; // 0: Assigned, 1: In Delivery, 2: Delivered, 3: Failed
    private Timestamp updateTime;

    // Extra info (nếu cần hiển thị trên JSP)
    private String shipperName;
    private String customerName;
    private String orderStatus;

    public ShippingHistory() {}

    public ShippingHistory(long id, long orderId, long shipperId, int status, Timestamp updateTime) {
        this.id = id;
        this.orderId = orderId;
        this.shipperId = shipperId;
        this.status = status;
        this.updateTime = updateTime;
    }

    // Getter & Setter
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }

    public long getShipperId() { return shipperId; }
    public void setShipperId(long shipperId) { this.shipperId = shipperId; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Timestamp getUpdateTime() { return updateTime; }
    public void setUpdateTime(Timestamp updateTime) { this.updateTime = updateTime; }

    public String getShipperName() { return shipperName; }
    public void setShipperName(String shipperName) { this.shipperName = shipperName; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }
}

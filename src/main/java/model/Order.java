package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private int orderId;
    private int customerId;
    private Integer courierId;
    private double totalAmount;
    private String shippingAddress;
    private String status;
    private String paymentStatus;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    private String customerName;
    private String courierName;
    private List<OrderItem> orderItems;
    
    public Order() {
        this.orderItems = new ArrayList<>();
    }
    
    public Order(int orderId, int customerId, Integer courierId, double totalAmount,
                 String shippingAddress, String status, String paymentStatus) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.courierId = courierId;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.status = status;
        this.paymentStatus = paymentStatus;
        this.orderItems = new ArrayList<>();
    }
    
    public String getFormattedTotal() {
        return String.format("Rp %.0f", totalAmount);
    }
    
    public String getStatusBadge() {
        switch (status) {
            case "pending": return "secondary";
            case "processing": return "info";
            case "shipped": return "primary";
            case "delivered": return "success";
            case "cancelled": return "danger";
            default: return "secondary";
        }
    }
    
    public String getStatusLabel() {
        switch (status) {
            case "pending": return "Menunggu";
            case "processing": return "Diproses";
            case "shipped": return "Dikirim";
            case "delivered": return "Selesai";
            case "cancelled": return "Dibatalkan";
            default: return status;
        }
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
    
    public Integer getCourierId() {
        return courierId;
    }
    
    public void setCourierId(Integer courierId) {
        this.courierId = courierId;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getShippingAddress() {
        return shippingAddress;
    }
    
    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
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
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCourierName() {
        return courierName;
    }
    
    public void setCourierName(String courierName) {
        this.courierName = courierName;
    }
    
    public List<OrderItem> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }
    
    public void addOrderItem(OrderItem item) {
        this.orderItems.add(item);
    }
}
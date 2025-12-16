package model;

import java.sql.Timestamp;

public class PaymentRecord {
    private int paymentId;
    private int orderId;
    private String paymentMethod;
    private double amount;
    private String paymentDetails;
    private String status;
    private Timestamp paymentDate;
    
    public PaymentRecord() {}
    
    public PaymentRecord(int paymentId, int orderId, String paymentMethod,
                        double amount, String paymentDetails, String status) {
        this.paymentId = paymentId;
        this.orderId = orderId;
        this.paymentMethod = paymentMethod;
        this.amount = amount;
        this.paymentDetails = paymentDetails;
        this.status = status;
    }
    
    public String getFormattedAmount() {
        return String.format("Rp %.0f", amount);
    }
    
    public int getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public double getAmount() {
        return amount;
    }
    
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    public String getPaymentDetails() {
        return paymentDetails;
    }
    
    public void setPaymentDetails(String paymentDetails) {
        this.paymentDetails = paymentDetails;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }
}
package model;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int productId;
    private int fishermanId;
    private int quantity;
    private double price;
    private double subtotal;
    
    private String productName;
    private String fishermanName;
    
    public OrderItem() {}
    
    public OrderItem(int orderItemId, int orderId, int productId, int fishermanId,
                     int quantity, double price, double subtotal) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.productId = productId;
        this.fishermanId = fishermanId;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
    }
    
    public String getFormattedPrice() {
        return String.format("Rp %.0f", price);
    }
    
    public String getFormattedSubtotal() {
        return String.format("Rp %.0f", subtotal);
    }
    
    public int getOrderItemId() {
        return orderItemId;
    }
    
    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public int getFishermanId() {
        return fishermanId;
    }
    
    public void setFishermanId(int fishermanId) {
        this.fishermanId = fishermanId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public double getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public String getFishermanName() {
        return fishermanName;
    }
    
    public void setFishermanName(String fishermanName) {
        this.fishermanName = fishermanName;
    }
}
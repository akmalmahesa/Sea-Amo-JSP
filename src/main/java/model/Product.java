package model;

import java.sql.Timestamp;

public class Product {
    private int productId;
    private int fishermanId;
    private String productName;
    private String description;
    private double price;
    private int stock;
    private String category;
    private String imageUrl;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    private String fishermanName;
    
    public Product() {}
    
    public Product(int productId, int fishermanId, String productName, String description,
                   double price, int stock, String category, String imageUrl, String status) {
        this.productId = productId;
        this.fishermanId = fishermanId;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category = category;
        this.imageUrl = imageUrl;
        this.status = status;
    }
    
    public boolean isAvailable() {
        return stock > 0 && "approved".equals(status);
    }
    
    public String getFormattedPrice() {
        return String.format("Rp %.0f", price);
    }
    
    // Getters and Setters
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
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public int getStock() {
        return stock;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
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
    
    public String getFishermanName() {
        return fishermanName;
    }
    
    public void setFishermanName(String fishermanName) {
        this.fishermanName = fishermanName;
    }
}
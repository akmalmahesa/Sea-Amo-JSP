package model;

import java.sql.Timestamp;

public class Cart {
    private int cartId;
    private int customerId;
    private int productId;
    private int quantity;
    private Timestamp addedAt;
    
    private Product product;
    private double subtotal;
    
    public Cart() {}
    
    public Cart(int cartId, int customerId, int productId, int quantity) {
        this.cartId = cartId;
        this.customerId = customerId;
        this.productId = productId;
        this.quantity = quantity;
    }
    
    public double calculateSubtotal() {
        if (product != null) {
            return product.getPrice() * quantity;
        }
        return 0;
    }
    
    public String getFormattedSubtotal() {
        return String.format("Rp %.0f", calculateSubtotal());
    }
    
    public int getCartId() {
        return cartId;
    }
    
    public void setCartId(int cartId) {
        this.cartId = cartId;
    }
    
    public int getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public Timestamp getAddedAt() {
        return addedAt;
    }
    
    public void setAddedAt(Timestamp addedAt) {
        this.addedAt = addedAt;
    }
    
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
        this.subtotal = calculateSubtotal();
    }
    
    public double getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
}
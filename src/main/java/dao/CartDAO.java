// ============================================================================
// CartDAO.java
// ============================================================================
package dao;

import model.Cart;
import model.Product;
import com.mycompany.seaamo.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    private ProductDAO productDAO = new ProductDAO();
    
    public List<Cart> getCartByCustomer(int customerId) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM cart WHERE customer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setCustomerId(rs.getInt("customer_id"));
                cart.setProductId(rs.getInt("product_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setAddedAt(rs.getTimestamp("added_at"));
                
                Product product = productDAO.getProductById(cart.getProductId());
                cart.setProduct(product);
                
                cartItems.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
    
    public boolean addToCart(Cart cart) {
        String sql = "INSERT INTO cart (customer_id, product_id, quantity) " +
                    "VALUES (?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE quantity = quantity + ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cart.getCustomerId());
            stmt.setInt(2, cart.getProductId());
            stmt.setInt(3, cart.getQuantity());
            stmt.setInt(4, cart.getQuantity());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateQuantity(int cartId, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, cartId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean removeFromCart(int cartId) {
        String sql = "DELETE FROM cart WHERE cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cartId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean clearCart(int customerId) {
        String sql = "DELETE FROM cart WHERE customer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int getCartCount(int customerId) {
        String sql = "SELECT COUNT(*) FROM cart WHERE customer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
// ============================================================================
// OrderDAO.java
// ============================================================================
package dao;

import model.Order;
import model.OrderItem;
import com.mycompany.seaamo.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    public int createOrder(Order order) {
        String sql = "INSERT INTO orders (customer_id, total_amount, shipping_address, " +
                    "status, payment_status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, order.getCustomerId());
            stmt.setDouble(2, order.getTotalAmount());
            stmt.setString(3, order.getShippingAddress());
            stmt.setString(4, order.getStatus());
            stmt.setString(5, order.getPaymentStatus());
            
            int affected = stmt.executeUpdate();
            
            if (affected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public boolean insertOrderItem(OrderItem item) {
        String sql = "INSERT INTO order_items (order_id, product_id, fisherman_id, " +
                    "quantity, price, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, item.getOrderId());
            stmt.setInt(2, item.getProductId());
            stmt.setInt(3, item.getFishermanId());
            stmt.setInt(4, item.getQuantity());
            stmt.setDouble(5, item.getPrice());
            stmt.setDouble(6, item.getSubtotal());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Order> getOrdersByCustomer(int customerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as customer_name, " +
                    "c.full_name as courier_name FROM orders o " +
                    "JOIN users u ON o.customer_id = u.user_id " +
                    "LEFT JOIN users c ON o.courier_id = c.user_id " +
                    "WHERE o.customer_id = ? ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                orders.add(createOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public List<Order> getOrdersByFisherman(int fishermanId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT DISTINCT o.*, u.full_name as customer_name, " +
                    "c.full_name as courier_name FROM orders o " +
                    "JOIN order_items oi ON o.order_id = oi.order_id " +
                    "JOIN users u ON o.customer_id = u.user_id " +
                    "LEFT JOIN users c ON o.courier_id = c.user_id " +
                    "WHERE oi.fisherman_id = ? ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, fishermanId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                orders.add(createOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public List<Order> getOrdersByCourier(int courierId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as customer_name FROM orders o " +
                    "JOIN users u ON o.customer_id = u.user_id " +
                    "WHERE o.courier_id = ? OR (o.courier_id IS NULL AND o.status = 'processing') " +
                    "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courierId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                orders.add(createOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as customer_name, " +
                    "c.full_name as courier_name FROM orders o " +
                    "JOIN users u ON o.customer_id = u.user_id " +
                    "LEFT JOIN users c ON o.courier_id = c.user_id " +
                    "ORDER BY o.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                orders.add(createOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.full_name as customer_name, " +
                    "c.full_name as courier_name FROM orders o " +
                    "JOIN users u ON o.customer_id = u.user_id " +
                    "LEFT JOIN users c ON o.courier_id = c.user_id " +
                    "WHERE o.order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return createOrderFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean assignCourier(int orderId, int courierId) {
        String sql = "UPDATE orders SET courier_id = ? WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courierId);
            stmt.setInt(2, orderId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.product_name, u.full_name as fisherman_name " +
                    "FROM order_items oi " +
                    "JOIN products p ON oi.product_id = p.product_id " +
                    "JOIN users u ON oi.fisherman_id = u.user_id " +
                    "WHERE oi.order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setFishermanId(rs.getInt("fisherman_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                item.setSubtotal(rs.getDouble("subtotal"));
                item.setProductName(rs.getString("product_name"));
                item.setFishermanName(rs.getString("fisherman_name"));
                
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    
    private Order createOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setCustomerId(rs.getInt("customer_id"));
        
        int courierId = rs.getInt("courier_id");
        order.setCourierId(rs.wasNull() ? null : courierId);
        
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setStatus(rs.getString("status"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        order.setCustomerName(rs.getString("customer_name"));
        
        try {
            order.setCourierName(rs.getString("courier_name"));
        } catch (SQLException e) {
            // courier_name might not exist in some queries
        }
        
        return order;
    }
}

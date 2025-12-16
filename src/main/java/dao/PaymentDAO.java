// ============================================================================
// PaymentDAO.java
// ============================================================================
package dao;

import model.PaymentRecord;
import com.mycompany.seaamo.DBConnection;
import java.sql.*;

public class PaymentDAO {
    
    public boolean insertPayment(PaymentRecord payment) {
        String sql = "INSERT INTO payments (order_id, payment_method, amount, " +
                    "payment_details, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, payment.getOrderId());
            stmt.setString(2, payment.getPaymentMethod());
            stmt.setDouble(3, payment.getAmount());
            stmt.setString(4, payment.getPaymentDetails());
            stmt.setString(5, payment.getStatus());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public PaymentRecord getPaymentByOrderId(int orderId) {
        String sql = "SELECT * FROM payments WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                PaymentRecord payment = new PaymentRecord();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setOrderId(rs.getInt("order_id"));
                payment.setPaymentMethod(rs.getString("payment_method"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentDetails(rs.getString("payment_details"));
                payment.setStatus(rs.getString("status"));
                payment.setPaymentDate(rs.getTimestamp("payment_date"));
                
                return payment;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE payments SET status = ? WHERE payment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, paymentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
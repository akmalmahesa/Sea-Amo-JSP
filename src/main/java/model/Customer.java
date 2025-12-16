package model;

public class Customer extends User {
    
    public Customer() {
        super();
    }
    
    public Customer(int userId, String username, String email, String fullName, 
                    String phone, String address, String status) {
        super(userId, username, email, fullName, phone, address, "customer", status);
    }
    
    @Override
    public String getDisplayRole() {
        return "Pembeli";
    }
    
    @Override
    public String getDashboardPath() {
        return "customer/dashboard.jsp";
    }
    
    public int getTotalOrders() {
        return 0;
    }
}
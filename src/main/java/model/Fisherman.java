package model;

public class Fisherman extends User {
    
    public Fisherman() {
        super();
    }
    
    public Fisherman(int userId, String username, String email, String fullName, 
                     String phone, String address, String status) {
        super(userId, username, email, fullName, phone, address, "fisherman", status);
    }
    
    @Override
    public String getDisplayRole() {
        return "Nelayan";
    }
    
    @Override
    public String getDashboardPath() {
        return "fisherman/dashboard.jsp";
    }
    
    public int getTotalProducts() {
        return 0;
    }
    
    public int getPendingOrders() {
        return 0;
    }
}
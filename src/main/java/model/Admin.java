package model;

public class Admin extends User {
    
    public Admin() {
        super();
    }
    
    public Admin(int userId, String username, String email, String fullName, 
                 String phone, String address, String status) {
        super(userId, username, email, fullName, phone, address, "admin", status);
    }
    
    @Override
    public String getDisplayRole() {
        return "Administrator";
    }
    
    @Override
    public String getDashboardPath() {
        return "admin/dashboard.jsp";
    }
    
    public boolean canManageUsers() {
        return true;
    }
    
    public boolean canApproveProducts() {
        return true;
    }
}
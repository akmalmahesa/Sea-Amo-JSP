package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
        
        String role = (String) session.getAttribute("role");
        
        if ("customer".equals(role)) {
            request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
        } else if ("fisherman".equals(role)) {
            request.getRequestDispatcher("fisherman/profile.jsp").forward(request, response);
        } else if ("courier".equals(role)) {
            request.getRequestDispatcher("courier/profile.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("updateProfile".equals(action)) {
            updateProfile(request, response);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Validate input
        if (email == null || email.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Email dan nama lengkap harus diisi!");
            doGet(request, response);
            return;
        }
        
        User user = userDAO.getUserById(userId);
        user.setEmail(email.trim());
        user.setFullName(fullName.trim());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddress(address != null ? address.trim() : "");
        
        boolean success = userDAO.updateUser(user);
        
        if (success) {
            // Update session
            session.setAttribute("fullName", fullName.trim());
            
            request.setAttribute("success", "Profil berhasil diperbarui!");
            request.setAttribute("user", user);
        } else {
            request.setAttribute("error", "Gagal memperbarui profil.");
            request.setAttribute("user", user);
        }
        
        doGet(request, response);
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Semua field password harus diisi!");
            doGet(request, response);
            return;
        }
        
        // Check password match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Password baru tidak cocok!");
            doGet(request, response);
            return;
        }
        
        // Check password length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password minimal 6 karakter!");
            doGet(request, response);
            return;
        }
        
        // Verify current password
        User user = userDAO.getUserById(userId);
        User verifyUser = userDAO.login(user.getUsername(), currentPassword);
        
        if (verifyUser == null) {
            request.setAttribute("error", "Password lama salah!");
            doGet(request, response);
            return;
        }
        
        // Update password
        boolean success = userDAO.updatePassword(userId, newPassword);
        
        if (success) {
            request.setAttribute("success", "Password berhasil diubah!");
        } else {
            request.setAttribute("error", "Gagal mengubah password.");
        }
        
        doGet(request, response);
    }
}
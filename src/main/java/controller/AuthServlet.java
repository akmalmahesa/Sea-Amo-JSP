package controller;

import dao.UserDAO;
import model.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            handleLogout(request, response);
        } else {
            // Menggunakan Context Path
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validasi input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username dan password harus diisi!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.login(username.trim(), password);
        
        if (user != null) {
            // Set session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());
            session.setAttribute("fullName", user.getFullName());
            
            String dashboardPath;
            String role = user.getRole();
            
            if ("customer".equals(role)) {
                dashboardPath = "/customer/dashboard.jsp";
            } else if ("fisherman".equals(role)) {
                dashboardPath = "/fisherman/dashboard.jsp";
            } else if ("admin".equals(role)) {
                dashboardPath = "/admin/dashboard.jsp";
            } else if ("courier".equals(role)) {
                dashboardPath = "/courier/dashboard.jsp";
            } else {
                dashboardPath = "/index.jsp";
            }
            
            response.sendRedirect(request.getContextPath() + dashboardPath);

        } else {
            request.setAttribute("error", "Username atau password salah!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        
        // Validasi input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "Semua field harus diisi!");
            forwardWithData(request, response);
            return;
        }
        
        // Validasi password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Password tidak cocok!");
            forwardWithData(request, response);
            return;
        }
        
        // Validasi password length
        if (password.length() < 6) {
            request.setAttribute("error", "Password minimal 6 karakter!");
            forwardWithData(request, response);
            return;
        }
        
        // Check username exists
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "Username sudah digunakan!");
            forwardWithData(request, response);
            return;
        }
        
        // Create user based on role - Polymorphism
        User user;
        switch (role) {
            case "fisherman":
                user = new Fisherman();
                break;
            case "customer":
                user = new Customer();
                break;
            case "courier":
                user = new Courier();
                break;
            case "admin":
                user = new Admin();
                break;
            default:
                user = new Customer();
        }
        
        user.setUsername(username.trim());
        user.setPassword(password); 
        user.setEmail(email.trim());
        user.setFullName(fullName.trim());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddress(address != null ? address.trim() : "");
        user.setRole(role);
        
        boolean success = userDAO.register(user);
        
        if (success) {
            request.setAttribute("success", "Registrasi berhasil! Silakan login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registrasi gagal! Silakan coba lagi.");
            forwardWithData(request, response);
        }
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Menggunakan Context Path
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    
    private void forwardWithData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Preserve form data on error
        request.setAttribute("username", request.getParameter("username"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("fullName", request.getParameter("fullName"));
        request.setAttribute("phone", request.getParameter("phone"));
        request.setAttribute("address", request.getParameter("address"));
        request.setAttribute("role", request.getParameter("role"));
        
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
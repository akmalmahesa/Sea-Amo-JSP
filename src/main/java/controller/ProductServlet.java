package controller;

import dao.ProductDAO;
import model.Product;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/product")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProductServlet extends HttpServlet {
    
    private ProductDAO productDAO;
    
    // NAMA FOLDER PENYIMPANAN
    private static final String UPLOAD_DIR = "uploads"; 
    
    // PATH GAMBAR DEFAULT (Pastikan file ini ada di assets/images/)
    private static final String DEFAULT_IMAGE = "assets/images/default-product.jpg"; 

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO(); 
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listProducts(request, response);
                break;
            case "view":
                viewProduct(request, response);
                break;
            case "search":
                searchProducts(request, response);
                break;
            case "myProducts":
                myProducts(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            case "customerDashboard":
                viewCustomerDashboard(request, response);
                break;
            default:
                listProducts(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "add";
        }
        
        switch (action) {
            case "add":
                addProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            case "updateStatus":
                updateProductStatus(request, response);
                break;
            default:
                listProducts(request, response);
        }
    }
    
    // =================================================================================
    // LOGIC UTAMA: CRUD PRODUK
    // =================================================================================

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        if (userId == null || !"fisherman".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            String productName = request.getParameter("productName");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String category = request.getParameter("category");
            
            // --- LOGIKA PENANGANAN GAMBAR (URL vs FILE) ---
            String imgMethod = request.getParameter("imgMethod"); // Ambil input radio
            String imageUrl = DEFAULT_IMAGE; // Default awal

            if ("url".equals(imgMethod)) {
                // Jika user pilih URL
                String urlInput = request.getParameter("imageUrlInput");
                if (urlInput != null && !urlInput.trim().isEmpty()) {
                    imageUrl = urlInput.trim();
                }
            } else {
                // Jika user pilih Upload File (atau default)
                String uploadedUrl = uploadProductImage(request);
                // Jika upload sukses (tidak null), pakai hasil upload
                if (uploadedUrl != null) {
                    imageUrl = uploadedUrl;
                }
            }
            // ----------------------------------------------
            
            Product product = new Product();
            product.setFishermanId(userId);
            product.setProductName(productName);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setCategory(category);
            product.setImageUrl(imageUrl);
            product.setStatus("approved"); 
            
            boolean success = productDAO.insertProduct(product);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/product?action=myProducts&success=added");
            } else {
                request.setAttribute("error", "Gagal menambahkan produk.");
                request.getRequestDispatcher("fisherman/addProduct.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("fisherman/addProduct.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            Product existingProduct = productDAO.getProductById(productId);
            
            // Cek kepemilikan
            if (existingProduct == null || existingProduct.getFishermanId() != userId) {
                response.sendRedirect(request.getContextPath() + "/product?action=myProducts&error=unauthorized");
                return;
            }
            
            String productName = request.getParameter("productName");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String category = request.getParameter("category");
            
            existingProduct.setProductName(productName);
            existingProduct.setDescription(description);
            existingProduct.setPrice(price);
            existingProduct.setStock(stock);
            existingProduct.setCategory(category);
            
            // --- LOGIKA UPDATE GAMBAR ---
            String imgMethod = request.getParameter("imgMethod");
            
            if ("url".equals(imgMethod)) {
                String urlInput = request.getParameter("imageUrlInput");
                if (urlInput != null && !urlInput.trim().isEmpty()) {
                    existingProduct.setImageUrl(urlInput.trim());
                }
            } else if ("file".equals(imgMethod)) {
                // Cek apakah ada file baru
                Part filePart = request.getPart("image");
                if (filePart != null && filePart.getSize() > 0) {
                    String newImageUrl = uploadProductImage(request);
                    if (newImageUrl != null) {
                        existingProduct.setImageUrl(newImageUrl);
                    }
                }
            }
            // Jika user tidak mengubah gambar (input kosong), gambar lama tetap tersimpan di existingProduct
            // -----------------------------
            
            boolean success = productDAO.updateProduct(existingProduct);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/product?action=myProducts&success=updated");
            } else {
                request.setAttribute("error", "Gagal mengupdate produk.");
                request.setAttribute("product", existingProduct);
                request.getRequestDispatcher("fisherman/editProduct.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/product?action=myProducts&error=update");
        }
    }
    
    // =================================================================================
    // FUNGSI UPLOAD KE FOLDER "uploads"
    // =================================================================================
    
    private String uploadProductImage(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("image");
        
        // Cek jika file kosong, kembalikan null
        if (filePart == null || filePart.getSize() == 0) {
            return null; 
        }
        
        String fileName = extractFileName(filePart);
        if (fileName.isEmpty() || "unknown".equals(fileName)) return null;
        
        // Generate nama unik agar tidak bentrok
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        
        // Lokasi absolut di server (build/web/uploads)
        String applicationPath = getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

        // Buat folder jika belum ada
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        String filePath = uploadFilePath + File.separator + uniqueFileName;
        
        // Simpan file
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
        }
        
        // Kembalikan path relatif (contoh: "uploads/1238123_ikan.jpg")
        // .replace agar path separator konsisten menjadi "/" untuk URL web
        return UPLOAD_DIR + "/" + uniqueFileName;
    }
    
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                String fileName = s.substring(s.indexOf("=") + 2, s.length() - 1);
                // Membersihkan path jika browser mengirim full path (IE/Edge lama)
                return fileName.substring(fileName.lastIndexOf(File.separator) + 1);
            }
        }
        return "unknown";
    }

    // =================================================================================
    // METODE READ & VIEW (Tidak berubah drastis dari sebelumnya)
    // =================================================================================
    
    private void viewCustomerDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        if (session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Product> products = productDAO.getApprovedProducts(); 
            request.setAttribute("products", products);
            request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=dbfetch"); 
        }
    }
    
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        List<Product> products;
        
        if (category != null && !category.isEmpty()) {
            products = productDAO.getProductsByCategory(category);
        } else {
            products = productDAO.getApprovedProducts();
        }
        
        request.setAttribute("products", products);
        request.getRequestDispatcher("productList.jsp").forward(request, response);
    }
    
    private void viewProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(productId);
            
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("productDetail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/product?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/product?action=list");
        }
    }
    
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("search");
        List<Product> products;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productDAO.searchProducts(keyword.trim());
        } else {
            products = productDAO.getApprovedProducts();
        }
        
        request.setAttribute("products", products);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("productList.jsp").forward(request, response);
    }
    
    private void myProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        List<Product> products = productDAO.getProductsByFisherman(userId);
        request.setAttribute("products", products);
        request.getRequestDispatcher("fisherman/products.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(productId);
            
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            
            if (product != null && product.getFishermanId() == userId) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("fisherman/editProduct.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/product?action=myProducts&error=unauthorized");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/product?action=myProducts");
        }
    }
    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(productId);
            
            if (product != null && product.getFishermanId() == userId) {
                productDAO.deleteProduct(productId);
                response.sendRedirect(request.getContextPath() + "/product?action=myProducts&success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/product?action=myProducts&error=unauthorized");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/product?action=myProducts");
        }
    }
    
    private void updateProductStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String status = request.getParameter("status");
            
            productDAO.updateStatus(productId, status);
            response.sendRedirect(request.getContextPath() + "/admin?action=products&success=updated");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin?action=products&error=update");
        }
    }
}
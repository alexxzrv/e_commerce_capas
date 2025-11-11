import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    // POST se usa para AGREGAR al carrito
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int productId = Integer.parseInt(request.getParameter("product_id"));

        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;
        
        String dbUrl = "jdbc:mysql://localhost:3306/e_commerce";
        String dbUser = "root";
        String dbPass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
            // 1. Verificar si ya está en el carrito
            String sqlCheck = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
            psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setInt(1, userId);
            psCheck.setInt(2, productId);
            rs = psCheck.executeQuery();

            if (rs.next()) {
                // 2. Actualizar cantidad si ya existe
                String sqlUpdate = "UPDATE cart SET quantity = quantity + 1 WHERE user_id = ? AND product_id = ?";
                psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, userId);
                psUpdate.setInt(2, productId);
                psUpdate.executeUpdate();
            } else {
                // 3. Agregar nuevo si no existe
                String sqlInsert = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, 1)";
                psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setInt(1, userId);
                psInsert.setInt(2, productId);
                psInsert.executeUpdate();
            }
            
            // 4. Redirigir a la página del carrito
            response.sendRedirect("cart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("products.jsp"); // Enviar a productos si hay error
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (psCheck != null) psCheck.close(); } catch (Exception e) {}
            try { if (psUpdate != null) psUpdate.close(); } catch (Exception e) {}
            try { if (psInsert != null) psInsert.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // GET se usa para ELIMINAR del carrito (usando ?remove=ID)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String removeId = request.getParameter("remove");
        
        // Si no hay parámetro "remove", solo mostramos la página (redirigiendo a cart.jsp)
        if (removeId == null || removeId.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        int cartItemId = Integer.parseInt(removeId);
        
        Connection conn = null;
        PreparedStatement psDelete = null;
        
        String dbUrl = "jdbc:mysql://localhost:3306/e_commerce";
        String dbUser = "root";
        String dbPass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
            String sqlDelete = "DELETE FROM cart WHERE id = ? AND user_id = ?";
            psDelete = conn.prepareStatement(sqlDelete);
            psDelete.setInt(1, cartItemId);
            psDelete.setInt(2, userId);
            psDelete.executeUpdate();
            
            response.sendRedirect("cart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp");
        } finally {
            try { if (psDelete != null) psDelete.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
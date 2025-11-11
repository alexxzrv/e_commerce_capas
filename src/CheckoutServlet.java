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

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("user_id");

        // (Aquí iría la lógica de procesar el pago con los datos del form...
        // ...pero lo estamos simulando)
        
        Connection conn = null;
        PreparedStatement psDelete = null;
        
        String dbUrl = "jdbc:mysql://localhost:3306/e_commerce";
        String dbUser = "root";
        String dbPass = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
            // Vaciar el carrito
            String sqlDelete = "DELETE FROM cart WHERE user_id = ?";
            psDelete = conn.prepareStatement(sqlDelete);
            psDelete.setInt(1, userId);
            psDelete.executeUpdate();
            
            // Simular número de pedido
            int orderNumber = (int)(Math.random() * 9000) + 1000;
            String message = "¡Pedido #" + orderNumber + " procesado con éxito!";

            // Enviar el mensaje de éxito de vuelta al JSP
            request.setAttribute("message", message);
            request.getRequestDispatcher("checkout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar el pedido.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        } finally {
            try { if (psDelete != null) psDelete.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
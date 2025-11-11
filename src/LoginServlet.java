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
// Importar la librería de Hashing
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String dbUrl = "jdbc:mysql://localhost:3306/e_commerce"; // Tu BD
        String dbUser = "root";
        String dbPass = "";
        String dbDriver = "com.mysql.cj.jdbc.Driver";

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(dbDriver);
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
            // Buscamos al usuario por su 'username'
            String sql = "SELECT * FROM users WHERE username = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Usuario encontrado, ahora verificamos la contraseña
                String hashedPassword = rs.getString("password");
                
                // Usamos BCrypt.checkpw() (equivale a password_verify() en PHP)
                if (BCrypt.checkpw(password, hashedPassword)) {
                    // ¡Contraseña correcta!
                    HttpSession session = request.getSession();
                    session.setAttribute("user_id", rs.getInt("id")); // Guardamos el ID
                    session.setAttribute("username", rs.getString("username"));
                    
                    response.sendRedirect("index.jsp"); // Mandamos al inicio
                } else {
                    // Contraseña incorrecta
                    request.setAttribute("error", "Credenciales incorrectas");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // Usuario no encontrado
                request.setAttribute("error", "Credenciales incorrectas");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error del servidor: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
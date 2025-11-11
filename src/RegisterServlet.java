import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
// Importar la librería de Hashing
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String dbUrl = "jdbc:mysql://localhost:3306/e_commerce";
        String dbUser = "root";
        String dbPass = "";
        String dbDriver = "com.mysql.cj.jdbc.Driver";

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Hasheamos la contraseña (equivale a password_hash() en PHP)
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        
        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;

        try {
            Class.forName(dbDriver);
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
            // 1. Verificar si usuario o email ya existen
            String sqlCheck = "SELECT id FROM users WHERE username = ? OR email = ?";
            psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setString(1, username);
            psCheck.setString(2, email);
            rs = psCheck.executeQuery();
            
            if (rs.next()) {
                // Usuario o email ya existe
                request.setAttribute("error", "Usuario o email ya existe");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                // 2. Insertar nuevo usuario
                String sqlInsert = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
                psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setString(1, username);
                psInsert.setString(2, email);
                psInsert.setString(3, hashedPassword);
                
                psInsert.executeUpdate();
                
                request.setAttribute("exito", "Usuario registrado. <a href='login.jsp'>Login</a>");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error del servidor: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (psCheck != null) psCheck.close(); } catch (Exception e) {}
            try { if (psInsert != null) psInsert.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
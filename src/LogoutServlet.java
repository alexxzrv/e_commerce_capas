import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Obtenemos la sesión actual, sin crear una nueva
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Invalidamos la sesión (borramos todos los datos)
            session.invalidate();
        }
        
        // 3. Redirigimos al usuario a la página de login
        response.sendRedirect("login.jsp");
    }
}
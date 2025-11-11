<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    // ==========================================================
    // 1. PROTEGER LA PÁGINA (Reemplazo del chequeo de sesión)
    // ==========================================================
    String emailUsuario = (String) session.getAttribute("email_usuario");
    
    if (emailUsuario == null) {
        // Si no hay usuario en la sesión, lo redirigimos al login
        response.sendRedirect("login.jsp");
        return; // Detenemos la ejecución de esta página
    }
    
    // Si llegamos aquí, el usuario sí está logueado.
    String nombreUsuario = (String) session.getAttribute("nombre_usuario");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Productos</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        .producto { border: 1px solid #ccc; padding: 10px; margin: 10px; }
        .producto h3 { margin-top: 0; }
    </style>
</head>
<body>
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <h2>Bienvenido, <%= nombreUsuario %></h2>
        <a href="logout">Cerrar Sesión</a>
    </div>
    
    <h1>Nuestros Productos</h1>

    <% 
        // ==========================================================
        // 2. LÓGICA DE MOSTRAR PRODUCTOS (Reemplazo de products.php)
        // ==========================================================
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String dbUrl = "jdbc:mysql://localhost:3306/tu_base_de_datos";
        String dbUser = "tu_usuario_db";
        String dbPass = "tu_contraseña_db";
        String dbDriver = "com.mysql.cj.jdbc.Driver";

        try {
            Class.forName(dbDriver);
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            
            String sql = "SELECT * FROM products"; // O como se llame tu tabla
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            // Bucle para mostrar los productos (igual que en PHP)
            while (rs.next()) {
                String nombreProducto = rs.getString("nombre");
                String descripcion = rs.getString("descripcion");
                double precio = rs.getDouble("precio");

                // Usamos out.println() para "imprimir" HTML desde Java
                out.println("<div class='producto'>");
                out.println("<h3>" + nombreProducto + "</h3>");
                out.println("<p>" + descripcion + "</p>");
                out.println("<h4>$" + precio + "</h4>");
                out.println("</div>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Error al cargar los productos: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>

</body>
</html>
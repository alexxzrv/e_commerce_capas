<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Inicio</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="header">
        <div class="navbar">
            <div class="logo">JAJIntegratedS</div>
            <div class="nav-links">
                <a href="index.jsp">Inicio</a>
                <a href="products.jsp">Productos</a>
                <a href="about.jsp">Nosotros</a>
                <% if(userId != null) { %>
                    <a href="cart.jsp">Carrito</a>
                    <a href="logout">Salir</a> <% } else { %>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Registro</a>
                <% } %>
            </div>
        </div>
    </div>

    <div class="container">
        <h1>Bienvenido a JAJIntegratedS</h1>
        <p>Tu tienda de tecnología de confianza</p>
        
        <h2>Productos Populares</h2>
        <div class="product-grid">
            <% 
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_commerce", "root", "");
                    String sql = "SELECT * FROM products LIMIT 4";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();
                    
                    while(rs.next()) {
            %>
            <div class="product-card">
                <div class="product-image"><%= rs.getString("image") %></div>
                <h3><%= rs.getString("name") %></h3>
                <p>$<%= rs.getString("price") %></p>
                <% if(userId != null) { %>
                    <form method="POST" action="cart">
                        <input type="hidden" name="product_id" value="<%= rs.getInt("id") %>">
                        <button type="submit" class="btn">Agregar al Carrito</button>
                    </form>
                <% } %>
            </div>
            <% 
                    } // Cierra el while
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Nosotros</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="header">
        <div class="navbar">
            <div class="logo">
                <a href="index.jsp" style="text-decoration: none; color: inherit; cursor: pointer;">JAJIntegratedS</a>
            </div>
            <div class="nav-links">
                <a href="index.jsp">Inicio</a>
                <a href="products.jsp">Productos</a>
                <a href="about.jsp">Nosotros</a>
                <% if(userId != null) { %>
                    <a href="cart.jsp">Carrito</a>
                    <a href="logout">Salir</a>
                <% } else { %>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Registro</a>
                <% } %>
            </div>
        </div>
    </div>

    <div class="container">
        <h1>Sobre Nosotros</h1>
        <div style="background: white; padding: 2rem; border-radius: 5px; margin: 1rem 0;">
            <h2>Misión</h2>
            <p>Ofrecer productos tecnológicos de calidad a precios accesibles para todos.</p>
        </div>
        <div style="background: white; padding: 2rem; border-radius: 5px; margin: 1rem 0;">
            <h2>Visión</h2>
            <p>Ser la tienda de tecnología preferida por los estudiantes y profesionales.</p>
        </div>
    </div>
</body>
</html>
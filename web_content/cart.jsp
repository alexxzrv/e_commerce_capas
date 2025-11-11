<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // 1. Proteger la página
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 2. Lógica para MOSTRAR el carrito
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    double total = 0.0;
    DecimalFormat df = new DecimalFormat("#.00");
    
    List<Map<String, String>> cartItems = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/e_commerce", "root", "");
        
        String sql = "SELECT c.*, p.name, p.price, p.image FROM cart c " +
                     "JOIN products p ON c.product_id = p.id WHERE c.user_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            double price = rs.getDouble("price");
            int quantity = rs.getInt("quantity");
            double subtotal = price * quantity;
            total += subtotal;

            item.put("id", rs.getString("id"));
            item.put("name", rs.getString("name"));
            item.put("image", rs.getString("image"));
            item.put("price", df.format(price));
            item.put("quantity", String.valueOf(quantity));
            item.put("subtotal", df.format(subtotal));
            
            cartItems.add(item);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Carrito</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="header">
        <div class="navbar">
            <div class="logo"><a href="index.jsp" style="text-decoration: none; color: inherit;">JAJIntegratedS</a></div>
            <div class="nav-links">
                <a href="index.jsp">Inicio</a>
                <a href="products.jsp">Productos</a>
                <a href="about.jsp">Nosotros</a>
                <a href="cart.jsp">Carrito</a>
                <a href="logout">Salir</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h1>Tu Carrito de Compras</h1>
        
        <% if(cartItems.isEmpty()) { %>
            <p>Tu carrito está vacío</p>
            <a href="products.jsp" class="btn">Ver Productos</a>
        <% } else { %>
            <table style="width: 100%; border-collapse: collapse; background: white;">
                <thead>
                    <tr style="background: #34495e; color: white;">
                        <th style="padding: 1rem;">Producto</th>
                        <th style="padding: 1rem;">Precio</th>
                        <th style="padding: 1rem;">Cantidad</th>
                        <th style="padding: 1rem;">Subtotal</th>
                        <th style="padding: 1rem;">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Map<String, String> item : cartItems) { %>
                    <tr style="border-bottom: 1px solid #ddd;">
                        <td style="padding: 1rem;">
                            <span style="font-size: 2rem;"><%= item.get("image") %></span>
                            <%= item.get("name") %>
                        </td>
                        <td style="padding: 1rem;">$<%= item.get("price") %></td>
                        <td style="padding: 1rem;"><%= item.get("quantity") %></td>
                        <td style="padding: 1rem;">$<%= item.get("subtotal") %></td>
                        <td style="padding: 1rem;">
                            <a href="cart?remove=<%= item.get("id") %>" style="color: red;">Eliminar</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            
            <div style="text-align: right; margin-top: 1rem;">
                <h3>Total: $<%= df.format(total) %></h3>
                <a href="checkout.jsp" class="btn" style="background: #27ae60;">Proceder al Pago</a>
            </div>
        <% } %>
    </div>
</body>
</html>
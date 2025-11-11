<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Proteger la página
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Obtener mensajes del Servlet
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="header">
        <div class="navbar">
            <div class="logo"><a href="index.jsp" style="text-decoration: none; color: inherit;">JAJIntegratedS</a></div>
        </div>
    </div>

    <div class="container">
        <% if (message != null) { %>
            <div style="background: #d4edda; padding: 1rem; border-radius: 5px; margin-bottom: 1rem;">
                <h2><%= message %></h2>
                <p><a href="products.jsp">Seguir comprando</a></p>
            </div>
        <% } else if (error != null) { %>
             <div style="background: #f8d7da; padding: 1rem; border-radius: 5px; margin-bottom: 1rem;">
                <h2 style="color: #721c24;"><%= error %></h2>
            </div>
        <% } else { %>
            <h1>Finalizar Compra</h1>
            
            <form method="POST" action="checkout" style="max-width: 500px;">
                <h3>Información de Pago (Simulación)</h3>
                
                <div class="form-group">
                    <label>Nombre en la tarjeta:</label>
                    <input type="text" name="card_name" required>
                </div>
                <div class="form-group">
                    <label>Número de tarjeta:</label>
                    <input type="text" name="card_number" placeholder="1234 5678 9012 3456" required>
                </div>
                <div style="display: flex; gap: 1rem;">
                    <div class="form-group" style="flex: 1;">
                        <label>Fecha expiración:</label>
                        <input type="text" name="exp_date" placeholder="MM/AA" required>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>CVV:</label>
                        <input type="text" name="cvv" required>
                    </div>
                </div>
                <button type="submit" class="btn" style="background: #27ae60; width: 100%; padding: 1rem;">
                    Confirmar Pago
                </button>
            </form>
        <% } %>
    </div>
</body>
</html>
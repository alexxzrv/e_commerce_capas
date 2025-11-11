<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registro</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <h2>Crear Cuenta</h2>
    
    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) {
            out.println("<p style='color:red;'>" + error + "</p>");
        }
    %>
    <% 
        String exito = (String) request.getAttribute("exito");
        if (exito != null) {
            out.println("<p style='color:green;'>" + exito + "</p>");
        }
    %>
    
    <form action="register" method="POST">
        Nombre: <input type="text" name="nombre" required><br>
        Email: <input type="email" name="email" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Registrarse">
    </form>
    
    <p>¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a></p>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <h2>Iniciar Sesión</h2>
    
    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) {
            out.println("<p style='color:red;'>" + error + "</p>");
        }
    %>
    
    <form action="login" method="POST">
        Email: <input type="email" name="email" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Ingresar">
    </form>
    
    <p>¿No tienes cuenta? <a href="register.jsp">Regístrate</a></p>
</body>
</html>
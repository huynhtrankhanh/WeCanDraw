<%@page import="java.sql.*"%>
<%@page import="model.User"%>
<%@page import="connectionDatabase.Database"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link href='https://cdn.jsdelivr.net/npm/boxicons@2.0.5/css/boxicons.min.css' rel='stylesheet'>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            background-image: url('frame1.png'); /* Path to your background image */
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: sans-serif;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.8);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 400px; /* Added for responsiveness */
            margin: 0 auto;    /* Center the form */
        }

        .login-form label {
            display: block;
            margin-bottom: 5px;
        }

        .login-form input[type="text"],
        .login-form input[type="password"],
        .login-form input[type="submit"] {
            width: calc(100% - 22px); /* Adjust for padding */
            padding: 10px 11px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .login-form input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
        }

        .login-form input[type="submit"]:hover {
            background-color: #45a049;
        }

        .error-message {
            color: red;
            margin-top: 10px;
        }

        /* Style for social media icons (adjust as needed) */
        .social-icons {
            margin-top: 20px;
        }
        .social-icons a {
            margin: 0 10px;
        }
        .social-icons i {
            font-size: 24px;
        }

        .form-links{
            margin-top:10px;
        }
        .form-links a {
            margin: 0 10px;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String errorMessage = null;

        if (username != null && password != null) {
            try (Connection conn = Database.getData();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE UserName = ? AND Password = ?")) {

                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect("Homepage.jsp"); // Use sendRedirect for better security and browser handling
                        return;
                    } else {
                        errorMessage = "Invalid username or password!";
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                errorMessage = "Database error occurred.";
            }
        }
    %>

    <div class="login-container">
        <form class="login-form" action="Login.jsp" method="post">
            <h1>Login</h1>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <% if (errorMessage != null) { %>
                <div class="error-message"><%= errorMessage %></div>
            <% } %>
            <input type="submit" value="Login">

            <div class="form-links">
                <a href="#">Forgot Password?</a>
                <a href="RegisterForm.html">Create Account</a>
            </div>

            <div class="social-icons">
                <span>Or login with:</span>
                <a href="#"><i class='bx bxl-facebook'></i></a>
                <a href="#"><i class='bx bxl-google'></i></a>
                <a href="#"><i class='bx bxl-discord'></i></a>
            </div>
        </form>
    </div>
</body>
</html>
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
    <link rel="stylesheet" href="/public/css/style.css">  
    <style>
        .error-message {
            color: red;
            display: none;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String errorMessage = null; // Store error message

    if (username != null || password != null) { // Check if at least one is provided
        if (username == null || username.trim().isEmpty()) {
            errorMessage = "Username is required.";
        } else if (password == null || password.trim().isEmpty()) {
            errorMessage = "Password is required.";
        } else {
            // ... (Your existing database query code) ...
        if (username != null && password != null) {
             try (Connection conn = Database.getData();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE UserName = ? AND Password = ?")) {

                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        RequestDispatcher dispatcher = request.getRequestDispatcher("Homepage.jsp");
                        dispatcher.forward(request, response);
                        return;
                    } else {
                       errorMessage = "Invalid username or password!"; 
                    }
                }
             } catch (SQLException e) {
                e.printStackTrace();
                errorMessage = "Database error occurred."; // Better error message
             }
        }
        }
    } // End of outer if


%>




<div class="l-form"> <div class="shape1"></div> <div class="shape2"></div>
        <div class="form"> <img src="/public/images/frame1.png" alt="" class="form__img">

         <form action="Login.jsp" method="post" class="form__content">
                <input type="hidden" name="Login" value="Login">  
                <h1 class="form__title">Login</h1>

                 <div class="form__div form__div-one"> <div class="form__icon"> <i class='bx bx-user-circle'></i> </div>
                <div class="form__div-input"> <label class="form__label">Username:</label> 
                    <input type="text" name="username" class="form__input" placeholder="Username" required>
                    <span class="error-message" id="usernameError" <% if (errorMessage != null && errorMessage.contains("Username")) { out.print("style='display: block;'"); } %>><%= (errorMessage != null && errorMessage.contains("Username")) ? errorMessage : "" %></span> </div> </div>


             <div class="form__div"> <div class="form__icon"> <i class='bx bx-lock' ></i> </div> <div class="form__div-input">
                    <label class="form__label">Password:</label> <input type="password" name="password" class="form__input" placeholder="Password" required>
                     <span class="error-message" id="passwordError" <% if (errorMessage != null && errorMessage.contains("Password")) { out.print("style='display: block;'"); } %>><%= (errorMessage != null && errorMessage.contains("Password")) ? errorMessage : "" %></span></div> </div>
                <% if (errorMessage != null && !errorMessage.contains("Username") && !errorMessage.contains("Password")) { %> <!–– Check error message not related to input––>
                    <div class="error-message" style="display: block;"><%= errorMessage %></div> <!–– Display general error––>
                <% } %>

                <a href="#" class="form__forgot">Forgot Password?</a> <input type="submit" class="form__button" value="Login">




                <div class="form__social"> <span class="form__social-text">Or login with</span> <a href="#" class="form__social-icon"><i class='bx bxl-facebook' ></i></a>
                    <a href="#" class="form__social-icon"><i class='bx bxl-google' ></i></a> <a href="#" class="form__social-icon"><i class='bx bxl-discord' ></i></a> </div>
                <div class="form__signup"> <span class="form__signup-text">Don't have an account?</span> <a href="RegisterForm.html" class="form__signup-link">Create Account</a> </div>

            </form>
        </div>
    </div>



</body>
</html>
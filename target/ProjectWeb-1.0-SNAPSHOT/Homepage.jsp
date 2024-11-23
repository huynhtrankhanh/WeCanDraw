<%@page import="java.util.concurrent.atomic.AtomicInteger"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Homepage</title>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        if (username != null) {
            AtomicInteger hitCounter = (AtomicInteger) application.getAttribute("hitCounter");
    %>
            <h1>Welcome, <%= username %>!</h1>
            <p>Hit Counter: <%= hitCounter.get() %></p>

           <%-- ... rest of your homepage content ... --%>
            <a href="logout.jsp">Logout</a> <%-- Logout link --%>
        <% } else { %>
            <p>You are not logged in. <a href="Login.jsp">Login</a></p>
        <% } %>
</body>
</html>
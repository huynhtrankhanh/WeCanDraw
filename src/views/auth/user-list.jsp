<%@ page import="java.util.List" %>
<%@ page import="murach.business.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>User List</title>
</head>
<body>
    <h1>List of Users</h1>
    <ul>
      <%  List<User> users = (List<User>)request.getAttribute("users");
                for (User user : users){%>

        <li><%= user.getUserName()%> <%= user.getEmail()%> (<%= user.getPassword()%>) </li>

      <%}%>

    </ul>
<p><a href="index.jsp">Return to Index</a></p>
</body>
</html>
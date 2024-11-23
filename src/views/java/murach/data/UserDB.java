package murach.data;

import murach.business.User;
import connectionDatabase.Database;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDB {

    public static int insert(User user) {
        Connection connection = null;
        PreparedStatement ps = null;

        try {
            connection = Database.getData();
            String query = "INSERT INTO user (UserName,Email,Password) VALUES (?, ?, ?)"; // Assumes your table is named 'users'
            

            ps = connection.prepareStatement(query);
            ps.setString(1, user.getUserName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());

            return ps.executeUpdate(); // Returns number of rows affected (should be 1 for successful insert)

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); // Handle exceptions appropriately in a real application (e.g., logging, error messages)
            return 0; // Or throw an exception
        } finally {
            try {
                if(ps != null) ps.close();
                if(connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }



    public static List<User> getAll() {
        List<User> users = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            connection = Database.getData();
            String query = "SELECT * FROM user"; // Assumes your table is named 'users'
            ps = connection.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setUserName(rs.getString("UserName"));      // Column names from database
                user.setEmail(rs.getString("Email"));
                user.setPassword(rs.getString("Password"));
                users.add(user);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
           // Handle exceptions properly (log, return error, etc.)
        } finally {
            try {
                if(rs != null) rs.close();
                if(ps != null) ps.close();
                if(connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace(); // Handle exceptions
            }
        }
        return users;
    }
}
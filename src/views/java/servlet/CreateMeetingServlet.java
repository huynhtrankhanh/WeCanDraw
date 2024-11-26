/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/CreateMeetingServlet")
public class CreateMeetingServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/projectweb?user=Dat"; // Replace with your DB URL
    private static final String DB_USER = "Dat"; // Replace with your DB user
    private static final String DB_PASSWORD = "tiendat@@812247"; // Replace with your DB password


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String meetingID = generateMeetingID();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(JoinMeetingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO meetings (meetingID) VALUES (?)")) {

            stmt.setString(1, meetingID);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 1) {
                response.setContentType("text/plain");
                response.getWriter().write(meetingID);
            } else {
                sendError(response, "Failed to create meeting in the database.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            sendError(response, "Database error: " + e.getMessage());
        }
    }

    private String generateMeetingID() {
        // Using UUID for better uniqueness (consider alternatives for very high volume)
        return UUID.randomUUID().toString();
    }


    private void sendError(HttpServletResponse response, String errorMessage) throws IOException {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 status code
        response.setContentType("text/plain");
        response.getWriter().write(errorMessage);
    }
}
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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/JoinMeetingServlet")
public class JoinMeetingServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/projectweb?user=Dat"; // Replace with your DB URL
    private static final String DB_USER = "Dat"; // Replace with your DB user
    private static final String DB_PASSWORD = "tiendat@@812247"; // Replace with your DB password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String meetingID = request.getParameter("meetingID");
        String username = request.getParameter("username");

        // Input validation (crucial for security!)
        if (meetingID == null || meetingID.isEmpty() || username == null || username.isEmpty()) {
            sendError(response, "Meeting ID and username are required.");
            return;
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(JoinMeetingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM meetings WHERE meetingID = ?")) {

            stmt.setString(1, meetingID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Meeting ID found – redirect to drawing room (replace with your actual redirect)
                    response.sendRedirect("drawing_room.jsp?meetingID=" + meetingID + "&username=" + username);
                } else {
                    sendError(response, "Invalid meeting ID.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendError(response, "Database error: " + e.getMessage());
        }
    }

    private void sendError(HttpServletResponse response, String errorMessage) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 status code for bad input
        response.setContentType("text/plain");
        response.getWriter().write(errorMessage);
    }
}

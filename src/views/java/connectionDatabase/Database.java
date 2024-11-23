package connectionDatabase;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    private static String jdbcUrl = "jdbc:mysql://localhost:3306/projectweb?user=Dat";
    private static String dbuser = "Dat";
    private static String dbpassword = "tiendat@@812247";

    public static Connection getData() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(jdbcUrl, dbuser, dbpassword);
    }
}

package murach.email;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.List;

import murach.business.User;
import murach.data.UserDB;
@WebServlet(name="EmailList",urlPatterns={"/emailList"})
public class EmailListServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String url = "/Login.jsp";

        // get current action
        String action = request.getParameter("action");
        if (action == null) {
            action = "join";  // default action
        }

        // perform action and set URL to appropriate page
        if (action.equals("join")) {
            url = "/RegisterForm.html";    // the "join" page
        } else if (action.equals("add")) {
            // get parameters from the request
            String userName = request.getParameter("userName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // store data in User object and save User object in database
            User user = new User(userName, email, password);
            UserDB.insert(user);

            // set User object in request object and set URL
            
        } else if (action.equals("show")) {
            var result = UserDB.getAll();
            request.setAttribute("users", result);
            url = "/user-list.jsp";
        }

        // forward request and response objects to specified URL
        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
         if (action.equals("show")) {
             List<User> users = UserDB.getAll();
             request.setAttribute("users", users);
             String url = "/user-list.jsp";
             getServletContext().getRequestDispatcher(url).forward(request, response);

         }else {
             doPost(request, response);
         }



    }
}
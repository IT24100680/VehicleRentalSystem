package com.vehiclerental.controller.user;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class DeactivateUserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute(AppConstants.SESSION_USER_ID);
        String confirmDeactivate = request.getParameter("confirmDeactivate");

        if ("YES".equals(confirmDeactivate)) {
            boolean success = userDAO.deactivateUser(userId);

            if (success) {
                // Logout user
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/jsp/user/login.jsp?deactivated=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=deactivate");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
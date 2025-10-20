package com.vehiclerental.controller.user;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.UserDAO;
import com.vehiclerental.model.User;
import com.vehiclerental.util.PasswordUtil;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(AppConstants.SESSION_USER) != null) {
            String role = (String) session.getAttribute(AppConstants.SESSION_USER_ROLE);
            if (AppConstants.ROLE_ADMIN.equals(role)) {
                response.sendRedirect(request.getContextPath() + "/jsp/admin/adminDashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/user/customerDashboard.jsp");
            }
            return;
        }

        request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validation
        if (ValidationUtil.isNullOrEmpty(email) || ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("errorMessage", "Please enter email and password!");
            request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
            return;
        }

        // Hash password and authenticate
        String passwordHash = PasswordUtil.hashPassword(password);
        User user = userDAO.loginUser(email.trim().toLowerCase(), passwordHash);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute(AppConstants.SESSION_USER, user);
            session.setAttribute(AppConstants.SESSION_USER_ID, user.getUserId());
            session.setAttribute(AppConstants.SESSION_USER_ROLE, user.getRole());
            session.setAttribute(AppConstants.SESSION_USER_NAME, user.getFullName());
            session.setAttribute(AppConstants.SESSION_USER_EMAIL, user.getEmail());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Redirect based on role
            if (AppConstants.ROLE_ADMIN.equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/jsp/admin/adminDashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/user/customerDashboard.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
        }
    }
}
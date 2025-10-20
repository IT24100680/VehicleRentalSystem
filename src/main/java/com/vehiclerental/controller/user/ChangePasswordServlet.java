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

public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/jsp/user/changePassword.jsp").forward(request, response);
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

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (ValidationUtil.isNullOrEmpty(currentPassword) ||
                ValidationUtil.isNullOrEmpty(newPassword) ||
                ValidationUtil.isNullOrEmpty(confirmPassword)) {
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("/jsp/user/changePassword.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPassword(newPassword)) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters with letters and numbers!");
            request.getRequestDispatcher("/jsp/user/changePassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New passwords do not match!");
            request.getRequestDispatcher("/jsp/user/changePassword.jsp").forward(request, response);
            return;
        }

        // Verify current password
        User user = userDAO.getUserById(userId);
        String currentPasswordHash = PasswordUtil.hashPassword(currentPassword);

        if (!currentPasswordHash.equals(user.getPasswordHash())) {
            request.setAttribute("errorMessage", "Current password is incorrect!");
            request.getRequestDispatcher("/jsp/user/changePassword.jsp").forward(request, response);
            return;
        }

        // Update password
        String newPasswordHash = PasswordUtil.hashPassword(newPassword);
        boolean success = userDAO.changePassword(userId, newPasswordHash);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/profile?success=password");
        } else {
            request.setAttribute("errorMessage", "Password change failed! Please try again.");
            request.getRequestDispatcher("/jsp/user/changePassword.jsp").forward(request, response);
        }
    }
}
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
import java.sql.Date;
import java.util.List;

public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin role
        HttpSession session = request.getSession(false);
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            User user = userDAO.getUserById(userId);
            request.setAttribute("user", user);
            request.setAttribute("action", "edit");
        } else if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.deleteUser(userId);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
            return;
        } else if ("activate".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.activateUser(userId);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=activated");
            return;
        } else if ("deactivate".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.deactivateUser(userId);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=deactivated");
            return;
        }

        // Get all users
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/jsp/admin/manageUsers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Add new user
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String phone = request.getParameter("phone");

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            user.setRole(role);
            user.setPhone(phone);

            boolean success = userDAO.registerUser(user);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=add");
            }

        } else if ("update".equals(action)) {
            // Update user
            int userId = Integer.parseInt(request.getParameter("userId"));
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String zipCode = request.getParameter("zipCode");

            User user = new User();
            user.setUserId(userId);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setAddress(address);
            user.setCity(city);
            user.setState(state);
            user.setZipCode(zipCode);

            boolean success = userDAO.updateUser(user);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=update");
            }
        }
    }
}
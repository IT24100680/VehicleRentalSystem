package com.vehiclerental.controller.user;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.UserDAO;
import com.vehiclerental.model.User;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

public class UpdateProfileServlet extends HttpServlet {

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

        int userId = (int) session.getAttribute(AppConstants.SESSION_USER_ID);
        User user = userDAO.getUserById(userId);

        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("/jsp/user/editProfile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
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

        // Get form parameters
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipCode = request.getParameter("zipCode");
        String licenseNumber = request.getParameter("licenseNumber");
        String dateOfBirth = request.getParameter("dateOfBirth");

        // Validation
        if (ValidationUtil.isNullOrEmpty(fullName)) {
            request.setAttribute("errorMessage", "Full name is required!");
            doGet(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setUserId(userId);
        user.setFullName(ValidationUtil.sanitizeInput(fullName));
        user.setPhone(phone);
        user.setAddress(address);
        user.setCity(city);
        user.setState(state);
        user.setZipCode(zipCode);
        user.setLicenseNumber(licenseNumber);

        if (!ValidationUtil.isNullOrEmpty(dateOfBirth)) {
            user.setDateOfBirth(Date.valueOf(dateOfBirth));
        }

        // Update user
        boolean success = userDAO.updateUser(user);

        if (success) {
            // Update session
            session.setAttribute(AppConstants.SESSION_USER_NAME, fullName);
            response.sendRedirect(request.getContextPath() + "/profile?success=updated");
        } else {
            request.setAttribute("errorMessage", "Update failed! Please try again.");
            doGet(request, response);
        }
    }
}
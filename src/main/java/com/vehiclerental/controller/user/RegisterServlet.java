package com.vehiclerental.controller.user;

import com.vehiclerental.dao.UserDAO;
import com.vehiclerental.model.User;
import com.vehiclerental.util.PasswordUtil;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipCode = request.getParameter("zipCode");
        String licenseNumber = request.getParameter("licenseNumber");
        String dateOfBirth = request.getParameter("dateOfBirth");

        // Validation
        if (ValidationUtil.isNullOrEmpty(fullName) || ValidationUtil.isNullOrEmpty(email) ||
                ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("errorMessage", "Please fill all required fields!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Invalid email format!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters with letters and numbers!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("errorMessage", "Email already registered!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setFullName(ValidationUtil.sanitizeInput(fullName));
        user.setEmail(email.trim().toLowerCase());
        user.setPhone(phone);
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setRole("CUSTOMER");
        user.setAddress(address);
        user.setCity(city);
        user.setState(state);
        user.setZipCode(zipCode);
        user.setLicenseNumber(licenseNumber);

        if (!ValidationUtil.isNullOrEmpty(dateOfBirth)) {
            user.setDateOfBirth(Date.valueOf(dateOfBirth));
        }

        // Register user
        boolean success = userDAO.registerUser(user);

        if (success) {
            request.setAttribute("successMessage", "Registration successful! Please login.");
            response.sendRedirect(request.getContextPath() + "/jsp/user/login.jsp?success=registered");
        } else {
            request.setAttribute("errorMessage", "Registration failed! Please try again.");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
        }
    }
}
package com.vehiclerental.controller.vehicle;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Vehicle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class VehicleListServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String category = request.getParameter("category");
        List<Vehicle> vehicles;

        if (category != null && !category.isEmpty()) {
            vehicles = vehicleDAO.getVehiclesByCategory(category);
        } else {
            vehicles = vehicleDAO.getAvailableVehicles();
        }

        request.setAttribute("vehicles", vehicles);
        request.getRequestDispatcher("/jsp/vehicle/viewVehicles.jsp").forward(request, response);
    }
}
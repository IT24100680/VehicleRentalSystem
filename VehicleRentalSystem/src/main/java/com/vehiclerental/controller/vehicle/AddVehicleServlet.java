package com.vehiclerental.controller.vehicle;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Vehicle;
import com.vehiclerental.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

public class AddVehicleServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/jsp/admin/manageVehicles.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String vehicleName = request.getParameter("vehicleName");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String yearStr = request.getParameter("year");
        String category = request.getParameter("category");
        String fuelType = request.getParameter("fuelType");
        String transmission = request.getParameter("transmission");
        String seatingCapacityStr = request.getParameter("seatingCapacity");
        String pricePerDayStr = request.getParameter("pricePerDay");
        String vehicleNumber = request.getParameter("vehicleNumber");
        String color = request.getParameter("color");
        String imageUrl = request.getParameter("imageUrl");
        String features = request.getParameter("features");

        // Validation
        if (ValidationUtil.isNullOrEmpty(vehicleName) || ValidationUtil.isNullOrEmpty(brand) ||
                ValidationUtil.isNullOrEmpty(pricePerDayStr)) {
            request.setAttribute("errorMessage", "Please fill all required fields!");
            request.getRequestDispatcher("/jsp/admin/manageVehicles.jsp").forward(request, response);
            return;
        }

        // Create vehicle object
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleName(ValidationUtil.sanitizeInput(vehicleName));
        vehicle.setBrand(brand);
        vehicle.setModel(model);
        vehicle.setYear(Integer.parseInt(yearStr));
        vehicle.setCategory(category);
        vehicle.setFuelType(fuelType);
        vehicle.setTransmission(transmission);
        vehicle.setSeatingCapacity(Integer.parseInt(seatingCapacityStr));
        vehicle.setPricePerDay(new BigDecimal(pricePerDayStr));
        vehicle.setVehicleNumber(vehicleNumber);
        vehicle.setColor(color);
        vehicle.setImageUrl(imageUrl);
        vehicle.setFeatures(features);
        vehicle.setAvailabilityStatus(AppConstants.VEHICLE_AVAILABLE);

        // Add vehicle
        boolean success = vehicleDAO.addVehicle(vehicle);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/manageVehicles?success=added");
        } else {
            request.setAttribute("errorMessage", "Failed to add vehicle!");
            request.getRequestDispatcher("/jsp/admin/manageVehicles.jsp").forward(request, response);
        }
    }
}
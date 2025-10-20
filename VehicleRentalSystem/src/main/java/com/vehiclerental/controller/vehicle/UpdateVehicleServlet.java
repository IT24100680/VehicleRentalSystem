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
import java.math.BigDecimal;

public class UpdateVehicleServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !AppConstants.ROLE_ADMIN.equals(session.getAttribute(AppConstants.SESSION_USER_ROLE))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        String vehicleName = request.getParameter("vehicleName");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        int year = Integer.parseInt(request.getParameter("year"));
        String category = request.getParameter("category");
        String fuelType = request.getParameter("fuelType");
        String transmission = request.getParameter("transmission");
        int seatingCapacity = Integer.parseInt(request.getParameter("seatingCapacity"));
        BigDecimal pricePerDay = new BigDecimal(request.getParameter("pricePerDay"));
        String vehicleNumber = request.getParameter("vehicleNumber");
        String color = request.getParameter("color");
        String imageUrl = request.getParameter("imageUrl");
        String features = request.getParameter("features");
        String availabilityStatus = request.getParameter("availabilityStatus");

        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(vehicleId);
        vehicle.setVehicleName(vehicleName);
        vehicle.setBrand(brand);
        vehicle.setModel(model);
        vehicle.setYear(year);
        vehicle.setCategory(category);
        vehicle.setFuelType(fuelType);
        vehicle.setTransmission(transmission);
        vehicle.setSeatingCapacity(seatingCapacity);
        vehicle.setPricePerDay(pricePerDay);
        vehicle.setVehicleNumber(vehicleNumber);
        vehicle.setColor(color);
        vehicle.setImageUrl(imageUrl);
        vehicle.setFeatures(features);
        vehicle.setAvailabilityStatus(availabilityStatus);

        boolean success = vehicleDAO.updateVehicle(vehicle);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/manageVehicles?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manageVehicles?error=update");
        }
    }
}
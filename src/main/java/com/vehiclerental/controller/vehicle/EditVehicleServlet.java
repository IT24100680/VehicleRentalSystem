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

public class EditVehicleServlet extends HttpServlet {

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

        String vehicleIdStr = request.getParameter("id");
        if (vehicleIdStr == null || vehicleIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manageVehicles");
            return;
        }

        int vehicleId = Integer.parseInt(vehicleIdStr);
        Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);

        if (vehicle != null) {
            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("/jsp/admin/editVehicle.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manageVehicles?error=notfound");
        }
    }
}

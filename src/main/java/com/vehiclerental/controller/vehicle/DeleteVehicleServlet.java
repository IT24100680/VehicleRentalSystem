package com.vehiclerental.controller.vehicle;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.VehicleDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class DeleteVehicleServlet extends HttpServlet {

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

        int vehicleId = Integer.parseInt(request.getParameter("id"));
        boolean success = vehicleDAO.deleteVehicle(vehicleId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/manageVehicles?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manageVehicles?error=delete");
        }
    }
}
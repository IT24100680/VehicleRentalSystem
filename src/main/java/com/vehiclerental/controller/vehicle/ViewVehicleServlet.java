package com.vehiclerental.controller.vehicle;

import com.vehiclerental.config.AppConstants;
import com.vehiclerental.dao.FeedbackDAO;
import com.vehiclerental.dao.VehicleDAO;
import com.vehiclerental.model.Feedback;
import com.vehiclerental.model.Vehicle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class ViewVehicleServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        vehicleDAO = new VehicleDAO();
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String vehicleIdStr = request.getParameter("id");

        if (vehicleIdStr == null || vehicleIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/vehicles");
            return;
        }

        int vehicleId = Integer.parseInt(vehicleIdStr);
        Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);

        if (vehicle != null) {
            // Get feedbacks for this vehicle
            List<Feedback> feedbacks = feedbackDAO.getFeedbacksByVehicleId(vehicleId);
            double avgRating = feedbackDAO.getAverageRating(vehicleId);
            int reviewCount = feedbackDAO.getFeedbackCount(vehicleId);

            request.setAttribute("vehicle", vehicle);
            request.setAttribute("feedbacks", feedbacks);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviewCount);

            request.getRequestDispatcher("/jsp/vehicle/vehicleDetails.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/vehicles");
        }
    }
}
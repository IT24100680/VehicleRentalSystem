<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-tachometer-alt"></i> Admin Panel</h3>
    </div>

    <ul class="sidebar-menu">
        <li class="active">
            <a href="${pageContext.request.contextPath}/jsp/admin/adminDashboard.jsp">
                <i class="fas fa-home"></i>
                <span>Dashboard</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users"></i>
                <span>Manage Users</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/manageVehicles">
                <i class="fas fa-car"></i>
                <span>Manage Vehicles</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/bookings">
                <i class="fas fa-calendar-check"></i>
                <span>Bookings</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/viewPayments">
                <i class="fas fa-credit-card"></i>
                <span>Payments</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/viewFeedback">
                <i class="fas fa-star"></i>
                <span>Feedbacks</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/viewTickets">
                <i class="fas fa-ticket-alt"></i>
                <span>Support Tickets</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/profile">
                <i class="fas fa-user-cog"></i>
                <span>Profile</span>
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>
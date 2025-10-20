<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>${param.title != null ? param.title : 'Vehicle Rental System'}</title>

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/image-fixes.css">

    <!-- Animate.css -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar">
    <div class="container">
        <div class="nav-wrapper">
            <div class="logo">
                <i class="fas fa-car"></i>
                <span>AutoRent</span>
            </div>

            <ul class="nav-menu" id="navMenu">
                <li><a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/vehicles"><i class="fas fa-car-side"></i> Vehicles</a></li>
                <li><a href="${pageContext.request.contextPath}/viewFeedback"><i class="fas fa-star"></i> Reviews</a></li>

                <c:choose>
                    <c:when test="${sessionScope.loggedInUser != null}">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'ADMIN'}">
                                <li><a href="${pageContext.request.contextPath}/jsp/admin/adminDashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Users</a></li>
                                <li><a href="${pageContext.request.contextPath}/viewBookings"><i class="fas fa-calendar-check"></i> Bookings</a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/jsp/user/customerDashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                                <li><a href="${pageContext.request.contextPath}/viewBookings"><i class="fas fa-calendar-check"></i> My Bookings</a></li>
                                <li><a href="${pageContext.request.contextPath}/viewTickets"><i class="fas fa-ticket-alt"></i> Support</a></li>
                            </c:otherwise>
                        </c:choose>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle">
                                <i class="fas fa-user-circle"></i> ${sessionScope.userName}
                                <i class="fas fa-chevron-down"></i>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Profile</a></li>
                                <li><a href="${pageContext.request.contextPath}/changePassword"><i class="fas fa-key"></i> Change Password</a></li>
                                <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/login" class="btn-login"><i class="fas fa-sign-in-alt"></i> Login</a></li>
                        <li><a href="${pageContext.request.contextPath}/register" class="btn-register"><i class="fas fa-user-plus"></i> Register</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>

            <div class="hamburger" id="hamburger">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    </div>
</nav>

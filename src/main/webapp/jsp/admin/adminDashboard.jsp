<%@ page import="com.vehiclerental.dao.*" %>
<%@ include file="../common/header.jsp" %>

<%
    // Fetch dashboard statistics
    UserDAO userDAO = new UserDAO();
    VehicleDAO vehicleDAO = new VehicleDAO();
    BookingDAO bookingDAO = new BookingDAO();
    PaymentDAO paymentDAO = new PaymentDAO();
    TicketDAO ticketDAO = new TicketDAO();

    int totalUsers = userDAO.getTotalUserCount();
    int totalVehicles = vehicleDAO.getTotalVehicleCount();
    int availableVehicles = vehicleDAO.getAvailableVehicleCount();
    int totalBookings = bookingDAO.getTotalBookingCount();
    int openTickets = ticketDAO.getOpenTicketCount();
    double totalRevenue = paymentDAO.getTotalRevenue();

    request.setAttribute("totalUsers", totalUsers);
    request.setAttribute("totalVehicles", totalVehicles);
    request.setAttribute("availableVehicles", availableVehicles);
    request.setAttribute("totalBookings", totalBookings);
    request.setAttribute("openTickets", openTickets);
    request.setAttribute("totalRevenue", totalRevenue);

    request.setAttribute("pendingBookings", bookingDAO.getPendingBookings());
    request.setAttribute("pendingPayments", paymentDAO.getPendingPayments());
    request.setAttribute("openTicketsList", ticketDAO.getOpenTickets());
%>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
            <div class="admin-user">
                <i class="fas fa-user-shield"></i>
                <span>Admin: ${sessionScope.userName}</span>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card stat-primary">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-details">
                    <p>Total Users</p>
                    <h2>${totalUsers}</h2>
                    <span class="stat-change positive">
                        <i class="fas fa-arrow-up"></i> 12% from last month
                    </span>
                </div>
            </div>

            <div class="stat-card stat-success">
                <div class="stat-icon">
                    <i class="fas fa-car"></i>
                </div>
                <div class="stat-details">
                    <p>Total Vehicles</p>
                    <h2>${totalVehicles}</h2>
                    <span class="stat-info">
                        <i class="fas fa-check-circle"></i> ${availableVehicles} Available
                    </span>
                </div>
            </div>

            <div class="stat-card stat-warning">
                <div class="stat-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="stat-details">
                    <p>Total Bookings</p>
                    <h2>${totalBookings}</h2>
                    <span class="stat-change positive">
                        <i class="fas fa-arrow-up"></i> 8% from last month
                    </span>
                </div>
            </div>

            <div class="stat-card stat-danger">
                <div class="stat-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <div class="stat-details">
                    <p>Open Tickets</p>
                    <h2>${openTickets}</h2>
                    <span class="stat-info">
                        <i class="fas fa-exclamation-circle"></i> Needs Attention
                    </span>
                </div>
            </div>

            <div class="stat-card stat-info">
                <div class="stat-icon">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="stat-details">
                    <p>Total Revenue</p>
                    <h2>$${String.format("%.2f", totalRevenue)}</h2>
                    <span class="stat-change positive">
                        <i class="fas fa-arrow-up"></i> 15% from last month
                    </span>
                </div>
            </div>
        </div>

        <!-- Pending Approvals -->
        <div class="dashboard-grid">
            <!-- Pending Bookings -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h3><i class="fas fa-clock"></i> Pending Bookings</h3>
                    <a href="${pageContext.request.contextPath}/viewBookings" class="btn btn-sm btn-primary">View All</a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${pendingBookings != null && pendingBookings.size() > 0}">
                            <div class="list-group">
                                <c:forEach items="${pendingBookings}" var="booking" begin="0" end="4">
                                    <div class="list-item">
                                        <div class="list-item-content">
                                            <h4>${booking.userName}</h4>
                                            <p><i class="fas fa-car"></i> ${booking.vehicleName}</p>
                                            <small><i class="fas fa-calendar"></i> ${booking.startDate} to ${booking.endDate}</small>
                                        </div>
                                        <div class="list-item-actions">
                                            <form action="${pageContext.request.contextPath}/admin/approveBooking" method="POST" style="display:inline;">
                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                <input type="hidden" name="action" value="approve">
                                                <button type="submit" class="btn btn-sm btn-success" title="Approve">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/approveBooking" method="POST" style="display:inline;">
                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                <input type="hidden" name="action" value="reject">
                                                <button type="submit" class="btn btn-sm btn-danger" title="Reject">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state-small">
                                <i class="fas fa-check-circle"></i>
                                <p>No pending bookings</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Pending Payments -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h3><i class="fas fa-credit-card"></i> Pending Payments</h3>
                    <a href="${pageContext.request.contextPath}/viewPayments" class="btn btn-sm btn-primary">View All</a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${pendingPayments != null && pendingPayments.size() > 0}">
                            <div class="list-group">
                                <c:forEach items="${pendingPayments}" var="payment" begin="0" end="4">
                                    <div class="list-item">
                                        <div class="list-item-content">
                                            <h4>${payment.userName}</h4>
                                            <p><i class="fas fa-dollar-sign"></i> $${payment.amount}</p>
                                            <small><i class="fas fa-credit-card"></i> ${payment.paymentMethod}</small>
                                        </div>
                                        <div class="list-item-actions">
                                            <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                                <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                                <input type="hidden" name="action" value="approve_payment">
                                                <button type="submit" class="btn btn-sm btn-success" title="Approve">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                                <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                                <input type="hidden" name="action" value="reject_payment">
                                                <button type="submit" class="btn btn-sm btn-danger" title="Reject">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state-small">
                                <i class="fas fa-check-circle"></i>
                                <p>No pending payments</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Open Tickets -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h3><i class="fas fa-ticket-alt"></i> Open Support Tickets</h3>
                    <a href="${pageContext.request.contextPath}/viewTickets" class="btn btn-sm btn-primary">View All</a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${openTicketsList != null && openTicketsList.size() > 0}">
                            <div class="list-group">
                                <c:forEach items="${openTicketsList}" var="ticket" begin="0" end="4">
                                    <div class="list-item">
                                        <div class="list-item-content">
                                            <h4>${ticket.subject}</h4>
                                            <p><i class="fas fa-user"></i> ${ticket.userName}</p>
                                            <small>
                                                <span class="badge badge-${ticket.priority == 'High' || ticket.priority == 'Urgent' ? 'danger' : 'warning'}">
                                                        ${ticket.priority}
                                                </span>
                                                    ${ticket.category}
                                            </small>
                                        </div>
                                        <div class="list-item-actions">
                                            <a href="${pageContext.request.contextPath}/viewTickets?id=${ticket.ticketId}"
                                               class="btn btn-sm btn-info">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state-small">
                                <i class="fas fa-check-circle"></i>
                                <p>No open tickets</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js removed - no charts needed -->

<%@ include file="../common/footer.jsp" %>
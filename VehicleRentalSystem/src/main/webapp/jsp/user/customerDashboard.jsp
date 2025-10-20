<%@ include file="../common/header.jsp" %>

<div class="dashboard-container">
    <div class="container">
        <div class="dashboard-header">
            <h1><i class="fas fa-tachometer-alt"></i> Customer Dashboard</h1>
            <p>Welcome back, <strong>${sessionScope.userName}</strong>!</p>
        </div>

        <!-- Quick Stats -->
        <div class="stats-grid">
            <div class="stat-card stat-primary">
                <div class="stat-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="stat-details">
                    <h3>${userBookings != null ? userBookings.size() : 0}</h3>
                    <p>Total Bookings</p>
                </div>
            </div>

            <div class="stat-card stat-success">
                <div class="stat-icon">
                    <i class="fas fa-credit-card"></i>
                </div>
                <div class="stat-details">
                    <h3>${userPayments != null ? userPayments.size() : 0}</h3>
                    <p>Payments Made</p>
                </div>
            </div>

            <div class="stat-card stat-warning">
                <div class="stat-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <div class="stat-details">
                    <h3>${userTickets != null ? userTickets.size() : 0}</h3>
                    <p>Support Tickets</p>
                </div>
            </div>

            <div class="stat-card stat-info">
                <div class="stat-icon">
                    <i class="fas fa-star"></i>
                </div>
                <div class="stat-details">
                    <h3>${userFeedbacks != null ? userFeedbacks.size() : 0}</h3>
                    <p>Reviews Given</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
            <div class="action-grid">
                <a href="${pageContext.request.contextPath}/vehicles" class="action-card">
                    <i class="fas fa-car"></i>
                    <h3>Browse Vehicles</h3>
                    <p>Find your perfect ride</p>
                </a>

                <a href="${pageContext.request.contextPath}/viewBookings" class="action-card">
                    <i class="fas fa-list"></i>
                    <h3>My Bookings</h3>
                    <p>View all bookings</p>
                </a>

                <a href="${pageContext.request.contextPath}/viewPayments" class="action-card">
                    <i class="fas fa-receipt"></i>
                    <h3>Payment History</h3>
                    <p>Track your payments</p>
                </a>

                <a href="${pageContext.request.contextPath}/createTicket" class="action-card">
                    <i class="fas fa-headset"></i>
                    <h3>Get Support</h3>
                    <p>Raise a ticket</p>
                </a>
            </div>
        </div>

        <!-- Recent Bookings -->
        <div class="dashboard-section">
            <div class="section-header">
                <h2><i class="fas fa-calendar-alt"></i> Recent Bookings</h2>
                <a href="${pageContext.request.contextPath}/viewBookings" class="btn btn-sm btn-primary">View All</a>
            </div>

            <div class="table-responsive">
                <c:choose>
                    <c:when test="${userBookings != null && userBookings.size() > 0}">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Vehicle</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${userBookings}" var="booking" begin="0" end="4">
                                <tr>
                                    <td>#${booking.bookingId}</td>
                                    <td>${booking.vehicleName}</td>
                                    <td>${booking.startDate}</td>
                                    <td>${booking.endDate}</td>
                                    <td>$${booking.totalAmount}</td>
                                    <td>
                                            <span class="badge badge-${booking.bookingStatus == 'Approved' ? 'success' :
                                                                       booking.bookingStatus == 'Pending' ? 'warning' : 'danger'}">
                                                    ${booking.bookingStatus}
                                            </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/viewBookings?id=${booking.bookingId}"
                                           class="btn btn-sm btn-info">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h3>No bookings yet</h3>
                            <p>Start by browsing our vehicle collection</p>
                            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary">Browse Vehicles</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
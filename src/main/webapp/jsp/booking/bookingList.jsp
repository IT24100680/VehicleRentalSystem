<!-- FILE: src/main/webapp/jsp/booking/bookingList.jsp -->

<%@ include file="../common/header.jsp" %>

<div class="dashboard-section">
    <div class="container">
        <div class="section-header">
            <h1><i class="fas fa-calendar-check"></i> My Bookings</h1>
            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary">
                <i class="fas fa-plus"></i> New Booking
            </a>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'created'}">Booking created successfully!</c:when>
                    <c:when test="${param.success == 'updated'}">Booking updated successfully!</c:when>
                    <c:when test="${param.success == 'deleted'}">Booking cancelled successfully!</c:when>
                    <c:when test="${param.success == 'approved'}">Booking approved!</c:when>
                    <c:when test="${param.success == 'rejected'}">Booking rejected!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'cannot_edit'}">This booking cannot be edited!</c:when>
                    <c:when test="${param.error == 'cannot_delete'}">This booking cannot be deleted!</c:when>
                    <c:when test="${param.error == 'unauthorized'}">You are not authorized to perform this action!</c:when>
                    <c:when test="${param.error == 'update_failed'}">Failed to update booking!</c:when>
                    <c:when test="${param.error == 'delete_failed'}">Failed to delete booking!</c:when>
                </c:choose>
            </div>
        </c:if>

        <div class="table-responsive">
            <c:choose>
                <c:when test="${bookings != null && bookings.size() > 0}">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Vehicle</th>
                            <th>Pickup Date</th>
                            <th>Return Date</th>
                            <th>Days</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${bookings}" var="booking">
                            <tr>
                                <td><strong>#${booking.bookingId}</strong></td>
                                <td>${booking.vehicleName}</td>
                                <td>${booking.startDate}</td>
                                <td>${booking.endDate}</td>
                                <td>${booking.totalDays} days</td>
                                <td><strong>$${booking.totalAmount}</strong></td>
                                <td>
                                        <span class="badge badge-${
                                            booking.bookingStatus == 'Approved' ? 'success' :
                                            booking.bookingStatus == 'Pending' ? 'warning' :
                                            booking.bookingStatus == 'Rejected' ? 'danger' :
                                            'info'
                                        }">
                                                ${booking.bookingStatus}
                                        </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/viewBookings?id=${booking.bookingId}"
                                       class="btn btn-sm btn-info" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <c:if test="${booking.bookingStatus == 'Pending' || booking.bookingStatus == 'Rejected'}">
                                        <a href="${pageContext.request.contextPath}/editBooking?id=${booking.bookingId}"
                                           class="btn btn-sm btn-warning" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>

                                        <form action="${pageContext.request.contextPath}/deleteBooking" method="POST"
                                              style="display:inline;" onsubmit="return confirmDelete('Are you sure you want to cancel this booking?')">
                                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                            <button type="submit" class="btn btn-sm btn-danger" title="Cancel">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${booking.bookingStatus == 'Approved'}">
                                        <a href="${pageContext.request.contextPath}/createPayment?bookingId=${booking.bookingId}"
                                           class="btn btn-sm btn-success" title="Make Payment">
                                            <i class="fas fa-credit-card"></i>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h3>No bookings found</h3>
                        <p>Start by browsing our vehicle collection</p>
                        <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary">
                            <i class="fas fa-car"></i> Browse Vehicles
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    function confirmDelete(message) {
        return confirm(message);
    }
</script>

<%@ include file="../common/footer.jsp" %>
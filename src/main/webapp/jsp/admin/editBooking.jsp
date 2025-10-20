<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../common/header.jsp" %>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-edit"></i> Edit Booking</h1>
            <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Manage Bookings
            </a>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'update_failed'}">Failed to update booking!</c:when>
                    <c:when test="${param.error == 'notfound'}">Booking not found!</c:when>
                </c:choose>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-calendar-check"></i> Edit Booking #${booking.bookingId}</h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/editBooking" method="POST">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startDate">Start Date *</label>
                            <input type="date" id="startDate" name="startDate" class="form-control" 
                                   value="${booking.startDate}" required>
                        </div>

                        <div class="form-group">
                            <label for="endDate">End Date *</label>
                            <input type="date" id="endDate" name="endDate" class="form-control" 
                                   value="${booking.endDate}" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="pickupLocation">Pickup Location *</label>
                            <input type="text" id="pickupLocation" name="pickupLocation" class="form-control" 
                                   value="${booking.pickupLocation}" required>
                        </div>

                        <div class="form-group">
                            <label for="dropoffLocation">Drop-off Location *</label>
                            <input type="text" id="dropoffLocation" name="dropoffLocation" class="form-control" 
                                   value="${booking.dropoffLocation}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="specialRequests">Special Requests</label>
                        <textarea id="specialRequests" name="specialRequests" class="form-control" rows="3"
                                  placeholder="Any special requests or notes...">${booking.specialRequests}</textarea>
                    </div>

                    <!-- Display booking info -->
                    <div class="booking-info">
                        <h4><i class="fas fa-info-circle"></i> Booking Information</h4>
                        <div class="info-grid">
                            <div class="info-item">
                                <strong>Customer:</strong> ${booking.userName}
                            </div>
                            <div class="info-item">
                                <strong>Vehicle:</strong> ${booking.vehicleName}
                            </div>
                            <div class="info-item">
                                <strong>Total Days:</strong> ${booking.totalDays}
                            </div>
                            <div class="info-item">
                                <strong>Total Amount:</strong> $${booking.totalAmount}
                            </div>
                            <div class="info-item">
                                <strong>Status:</strong> 
                                <span class="badge badge-${booking.bookingStatus == 'Approved' ? 'success' : 
                                                           booking.bookingStatus == 'Pending' ? 'warning' : 
                                                           booking.bookingStatus == 'Rejected' ? 'danger' : 'info'}">
                                    ${booking.bookingStatus}
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Booking
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<style>
    .form-actions {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        padding-top: 2rem;
        border-top: 2px solid var(--light);
    }

    .booking-info {
        background: var(--light);
        padding: 1.5rem;
        border-radius: var(--radius-md);
        margin: 2rem 0;
    }

    .booking-info h4 {
        margin-bottom: 1rem;
        color: var(--primary-color);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
    }

    .info-item {
        padding: 0.5rem;
        background: var(--white);
        border-radius: var(--radius-sm);
        border-left: 3px solid var(--primary-color);
    }
</style>

<%@ include file="../common/footer.jsp" %>

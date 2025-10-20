<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../common/header.jsp" %>

<div class="dashboard-section">
    <div class="container">
        <div class="section-header">
            <h1><i class="fas fa-edit"></i> Edit Booking</h1>
            <a href="${pageContext.request.contextPath}/viewBookings" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to My Bookings
            </a>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'cannot_edit'}">This booking cannot be edited!</c:when>
                    <c:when test="${param.error == 'unauthorized'}">You are not authorized to edit this booking!</c:when>
                    <c:when test="${param.error == 'update_failed'}">Failed to update booking!</c:when>
                </c:choose>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-calendar-check"></i> Edit Booking #${booking.bookingId}</h3>
                <span class="badge badge-${booking.bookingStatus == 'Pending' ? 'warning' : 'danger'}">
                    ${booking.bookingStatus}
                </span>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/editBooking" method="POST">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startDate">Pickup Date *</label>
                            <input type="date" id="startDate" name="startDate" class="form-control" 
                                   value="${booking.startDate}" required min="${java.time.LocalDate.now()}"
                                   onchange="validateDates()">
                        </div>

                        <div class="form-group">
                            <label for="endDate">Return Date *</label>
                            <input type="date" id="endDate" name="endDate" class="form-control" 
                                   value="${booking.endDate}" required onchange="validateDates()">
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
                                <span class="badge badge-${booking.bookingStatus == 'Pending' ? 'warning' : 'danger'}">
                                    ${booking.bookingStatus}
                                </span>
                            </div>
                        </div>
                        
                        <c:if test="${booking.bookingStatus == 'Rejected' && booking.adminRemarks != null}">
                            <div class="admin-remarks">
                                <strong><i class="fas fa-comment"></i> Admin Remarks:</strong>
                                <p>${booking.adminRemarks}</p>
                            </div>
                        </c:if>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/viewBookings" class="btn btn-secondary">
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
        margin-bottom: 1rem;
    }

    .info-item {
        padding: 0.5rem;
        background: var(--white);
        border-radius: var(--radius-sm);
        border-left: 3px solid var(--primary-color);
    }

    .admin-remarks {
        background: var(--white);
        padding: 1rem;
        border-radius: var(--radius-sm);
        border-left: 3px solid var(--danger-color);
        margin-top: 1rem;
    }

    .admin-remarks strong {
        color: var(--danger-color);
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 0.5rem;
    }

    .admin-remarks p {
        margin: 0;
        color: var(--dark);
        font-style: italic;
    }
</style>

<script>
    function confirmDelete(message) {
        return confirm(message);
    }

    function validateDates() {
        const startDate = new Date(document.getElementById('startDate').value);
        const endDate = new Date(document.getElementById('endDate').value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        if (startDate < today) {
            alert('Pickup date cannot be in the past!');
            document.getElementById('startDate').value = '';
            return false;
        }

        if (endDate < startDate) {
            alert('Return date must be on or after pickup date!');
            document.getElementById('endDate').value = '';
            return false;
        }

        return true;
    }
</script>

<%@ include file="../common/footer.jsp" %>
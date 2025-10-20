<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../common/header.jsp" %>

<div class="dashboard-section">
    <div class="container">
        <div class="section-header">
            <h1><i class="fas fa-calendar-check"></i> Booking Details</h1>
            <a href="${pageContext.request.contextPath}/viewBookings" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to My Bookings
            </a>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'notfound'}">Booking not found!</c:when>
                    <c:when test="${param.error == 'unauthorized'}">You are not authorized to view this booking!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${booking != null}">
            <div class="booking-details-container">
                <!-- Booking Header -->
                <div class="booking-header">
                    <div class="booking-id">
                        <h2>Booking #${booking.bookingId}</h2>
                        <span class="badge badge-${booking.bookingStatus == 'Approved' ? 'success' : 
                                                   booking.bookingStatus == 'Pending' ? 'warning' : 
                                                   booking.bookingStatus == 'Rejected' ? 'danger' : 'info'}">
                            ${booking.bookingStatus}
                        </span>
                    </div>
                    <div class="booking-date">
                        <small>Created: ${booking.createdAt}</small>
                    </div>
                </div>

                <!-- Booking Information Grid -->
                <div class="booking-info-grid">
                    <!-- Vehicle Information -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <h3><i class="fas fa-car"></i> Vehicle Information</h3>
                        </div>
                        <div class="info-card-body">
                            <div class="info-item">
                                <strong>Vehicle:</strong> ${booking.vehicleName}
                            </div>
                            <div class="info-item">
                                <strong>Booking ID:</strong> #${booking.bookingId}
                            </div>
                        </div>
                    </div>

                    <!-- Booking Dates -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <h3><i class="fas fa-calendar-alt"></i> Booking Dates</h3>
                        </div>
                        <div class="info-card-body">
                            <div class="info-item">
                                <strong>Pickup Date:</strong> ${booking.startDate}
                            </div>
                            <div class="info-item">
                                <strong>Return Date:</strong> ${booking.endDate}
                            </div>
                            <div class="info-item">
                                <strong>Total Days:</strong> ${booking.totalDays} day${booking.totalDays > 1 ? 's' : ''}
                            </div>
                        </div>
                    </div>

                    <!-- Location Information -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <h3><i class="fas fa-map-marker-alt"></i> Location Details</h3>
                        </div>
                        <div class="info-card-body">
                            <div class="info-item">
                                <strong>Pickup Location:</strong> ${booking.pickupLocation}
                            </div>
                            <div class="info-item">
                                <strong>Drop-off Location:</strong> ${booking.dropoffLocation}
                            </div>
                        </div>
                    </div>

                    <!-- Payment Information -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <h3><i class="fas fa-dollar-sign"></i> Payment Information</h3>
                        </div>
                        <div class="info-card-body">
                            <div class="info-item">
                                <strong>Total Amount:</strong> 
                                <span class="amount">$${booking.totalAmount}</span>
                            </div>
                            <div class="info-item">
                                <strong>Status:</strong> 
                                <span class="badge badge-${booking.bookingStatus == 'Approved' ? 'success' : 
                                                           booking.bookingStatus == 'Pending' ? 'warning' : 'danger'}">
                                    ${booking.bookingStatus}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Special Requests -->
                <c:if test="${booking.specialRequests != null && !booking.specialRequests.isEmpty()}">
                    <div class="info-card">
                        <div class="info-card-header">
                            <h3><i class="fas fa-comment"></i> Special Requests</h3>
                        </div>
                        <div class="info-card-body">
                            <p>${booking.specialRequests}</p>
                        </div>
                    </div>
                </c:if>

                <!-- Admin Remarks (for rejected bookings) -->
                <c:if test="${booking.bookingStatus == 'Rejected' && booking.adminRemarks != null}">
                    <div class="info-card admin-remarks-card">
                        <div class="info-card-header">
                            <h3><i class="fas fa-exclamation-triangle"></i> Admin Remarks</h3>
                        </div>
                        <div class="info-card-body">
                            <p>${booking.adminRemarks}</p>
                        </div>
                    </div>
                </c:if>

                <!-- Action Buttons -->
                <div class="booking-actions">
                    <c:if test="${booking.bookingStatus == 'Pending' || booking.bookingStatus == 'Rejected'}">
                        <a href="${pageContext.request.contextPath}/editBooking?id=${booking.bookingId}" 
                           class="btn btn-warning">
                            <i class="fas fa-edit"></i> Edit Booking
                        </a>
                        
                        <form action="${pageContext.request.contextPath}/deleteBooking" method="POST" 
                              style="display:inline;" 
                              onsubmit="return confirm('Are you sure you want to cancel this booking?')">
                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-times"></i> Cancel Booking
                            </button>
                        </form>
                    </c:if>

                    <c:if test="${booking.bookingStatus == 'Approved'}">
                        <a href="${pageContext.request.contextPath}/createPayment?bookingId=${booking.bookingId}" 
                           class="btn btn-success">
                            <i class="fas fa-credit-card"></i> Make Payment
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/viewBookings" class="btn btn-secondary">
                        <i class="fas fa-list"></i> Back to Bookings
                    </a>
                </div>
            </div>
        </c:if>
    </div>
</div>

<style>
    .booking-details-container {
        max-width: 1000px;
        margin: 0 auto;
    }

    .booking-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 2rem;
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        margin-bottom: 2rem;
    }

    .booking-id h2 {
        margin: 0;
        color: var(--primary-color);
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .booking-date {
        color: var(--gray);
    }

    .booking-info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 2rem;
        margin-bottom: 2rem;
    }

    .info-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        overflow: hidden;
    }

    .info-card-header {
        background: var(--light);
        padding: 1rem 1.5rem;
        border-bottom: 2px solid var(--light);
    }

    .info-card-header h3 {
        margin: 0;
        color: var(--primary-color);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .info-card-body {
        padding: 1.5rem;
    }

    .info-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.5rem 0;
        border-bottom: 1px solid var(--light);
    }

    .info-item:last-child {
        border-bottom: none;
    }

    .info-item strong {
        color: var(--gray);
    }

    .amount {
        font-size: 1.2rem;
        font-weight: 700;
        color: var(--primary-color);
    }

    .admin-remarks-card {
        border-left: 4px solid var(--danger-color);
    }

    .admin-remarks-card .info-card-header {
        background: rgba(220, 53, 69, 0.1);
    }

    .admin-remarks-card .info-card-header h3 {
        color: var(--danger-color);
    }

    .booking-actions {
        display: flex;
        gap: 1rem;
        justify-content: center;
        padding: 2rem;
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        flex-wrap: wrap;
    }

    .booking-actions .btn {
        min-width: 150px;
    }

    @media (max-width: 768px) {
        .booking-header {
            flex-direction: column;
            gap: 1rem;
            text-align: center;
        }

        .booking-info-grid {
            grid-template-columns: 1fr;
        }

        .booking-actions {
            flex-direction: column;
        }

        .booking-actions .btn {
            width: 100%;
        }
    }
</style>

<%@ include file="../common/footer.jsp" %>
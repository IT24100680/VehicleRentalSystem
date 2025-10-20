<%@ include file="../common/header.jsp" %>

<div class="feedback-container">
    <div class="container">
        <div class="section-header">
            <h1><i class="fas fa-star"></i> Select Booking for Review</h1>
            <a href="${pageContext.request.contextPath}/viewFeedback" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Reviews
            </a>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'no_bookings'}">No completed bookings available for review!</c:when>
                    <c:when test="${param.error == 'already_reviewed'}">You have already reviewed this booking!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${eligibleBookings != null && eligibleBookings.size() > 0}">
                <div class="booking-selection-grid">
                    <c:forEach items="${eligibleBookings}" var="booking">
                        <div class="booking-card">
                            <div class="booking-card-header">
                                <h3>Booking #${booking.bookingId}</h3>
                                <span class="badge badge-success">${booking.bookingStatus}</span>
                            </div>
                            
                            <div class="booking-card-body">
                                <div class="vehicle-info">
                                    <i class="fas fa-car"></i>
                                    <strong>${booking.vehicleName}</strong>
                                </div>
                                
                                <div class="booking-dates">
                                    <div class="date-item">
                                        <i class="fas fa-calendar-check"></i>
                                        <span>Pickup: ${booking.startDate}</span>
                                    </div>
                                    <div class="date-item">
                                        <i class="fas fa-calendar-times"></i>
                                        <span>Return: ${booking.endDate}</span>
                                    </div>
                                </div>
                                
                                <div class="booking-summary">
                                    <div class="summary-item">
                                        <span>Duration:</span>
                                        <strong>${booking.totalDays} day${booking.totalDays > 1 ? 's' : ''}</strong>
                                    </div>
                                    <div class="summary-item">
                                        <span>Amount:</span>
                                        <strong>$${booking.totalAmount}</strong>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="booking-card-footer">
                                <a href="${pageContext.request.contextPath}/addFeedback?bookingId=${booking.bookingId}" 
                                   class="btn btn-primary btn-block">
                                    <i class="fas fa-star"></i> Write Review
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-calendar-times"></i>
                    <h3>No bookings available for review</h3>
                    <p>You need to have completed bookings to write reviews.</p>
                    <a href="${pageContext.request.contextPath}/viewBookings" class="btn btn-primary">
                        <i class="fas fa-calendar-check"></i> View My Bookings
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<style>
    .feedback-container {
        padding: 3rem 0;
    }

    .booking-selection-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 2rem;
        margin-top: 2rem;
    }

    .booking-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        overflow: hidden;
        transition: var(--transition);
    }

    .booking-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-lg);
    }

    .booking-card-header {
        background: var(--light);
        padding: 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid var(--light);
    }

    .booking-card-header h3 {
        margin: 0;
        color: var(--primary-color);
    }

    .booking-card-body {
        padding: 1.5rem;
    }

    .vehicle-info {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 1rem;
        font-size: 1.1rem;
        color: var(--primary-color);
    }

    .booking-dates {
        margin-bottom: 1rem;
    }

    .date-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 0.5rem;
        color: var(--gray);
    }

    .booking-summary {
        display: flex;
        justify-content: space-between;
        padding-top: 1rem;
        border-top: 1px solid var(--light);
    }

    .summary-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
    }

    .summary-item span {
        font-size: 0.9rem;
        color: var(--gray);
    }

    .summary-item strong {
        color: var(--primary-color);
        font-size: 1.1rem;
    }

    .booking-card-footer {
        padding: 1rem 1.5rem;
        background: var(--light);
        border-top: 1px solid var(--light);
    }

    .btn-block {
        width: 100%;
    }

    .empty-state {
        text-align: center;
        padding: 4rem 2rem;
        color: var(--gray);
    }

    .empty-state i {
        font-size: 4rem;
        margin-bottom: 1rem;
        color: var(--gray-light);
    }

    .empty-state h3 {
        margin-bottom: 1rem;
        color: var(--dark);
    }

    .empty-state p {
        margin-bottom: 2rem;
    }
</style>

<%@ include file="../common/footer.jsp" %>

<!-- FILE: src/main/webapp/jsp/feedback/addFeedback.jsp -->

<%@ include file="../common/header.jsp" %>

<div class="feedback-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/selectBookingForFeedback" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Booking Selection
        </a>

        <div class="feedback-box">
            <div class="card">
                <div class="card-header">
                    <h2><i class="fas fa-star"></i> Share Your Experience</h2>
                </div>

                <div class="card-body">
                    <div class="booking-info">
                        <h3>Booking Details</h3>
                        <div class="info-item">
                            <strong>Vehicle:</strong>
                            <span>${booking.vehicleName}</span>
                        </div>
                        <div class="info-item">
                            <strong>Booking ID:</strong>
                            <span>#${booking.bookingId}</span>
                        </div>
                    </div>

                    <c:if test="${errorMessage != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/addFeedback" method="POST" class="feedback-form">
                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                        <input type="hidden" name="vehicleId" value="${booking.vehicleId}">

                        <div class="form-group">
                            <label>
                                <i class="fas fa-star"></i> Your Rating *
                            </label>
                            <div class="star-rating">
                                <input type="radio" id="star5" name="rating" value="5" required>
                                <label for="star5" title="5 stars"><i class="fas fa-star"></i></label>

                                <input type="radio" id="star4" name="rating" value="4">
                                <label for="star4" title="4 stars"><i class="fas fa-star"></i></label>

                                <input type="radio" id="star3" name="rating" value="3">
                                <label for="star3" title="3 stars"><i class="fas fa-star"></i></label>

                                <input type="radio" id="star2" name="rating" value="2">
                                <label for="star2" title="2 stars"><i class="fas fa-star"></i></label>

                                <input type="radio" id="star1" name="rating" value="1">
                                <label for="star1" title="1 star"><i class="fas fa-star"></i></label>
                            </div>
                            <small class="form-text">Click to rate your experience</small>
                        </div>

                        <div class="form-group">
                            <label for="comments">
                                <i class="fas fa-comment"></i> Your Review *
                            </label>
                            <textarea id="comments" name="comments" class="form-control" rows="6"
                                      required placeholder="Tell us about your rental experience..."></textarea>
                        </div>

                        <div class="form-group">
                            <label class="checkbox-label">
                                <input type="checkbox" name="isAnonymous" value="true">
                                <span>Post as Anonymous</span>
                            </label>
                            <small class="form-text">Check this if you want to hide your name</small>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/selectBookingForFeedback" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> Submit Feedback
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .feedback-container {
        padding: 3rem 0;
    }

    .feedback-box {
        max-width: 800px;
        margin: 2rem auto;
    }

    .booking-info {
        background: var(--light);
        padding: 1.5rem;
        border-radius: var(--radius-md);
        margin-bottom: 2rem;
    }

    .booking-info h3 {
        margin-bottom: 1rem;
    }

    .info-item {
        display: flex;
        justify-content: space-between;
        padding: 0.5rem 0;
    }

    .star-rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: flex-end;
        gap: 0.5rem;
        font-size: 2.5rem;
    }

    .star-rating input {
        display: none;
    }

    .star-rating label {
        cursor: pointer;
        color: var(--gray-light);
        transition: var(--transition);
    }

    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label {
        color: var(--warning-color);
    }
</style>

<%@ include file="../common/footer.jsp" %>
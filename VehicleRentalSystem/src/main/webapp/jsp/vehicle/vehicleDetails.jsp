<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../common/header.jsp" %>

<div class="vehicle-details-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/vehicles" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Vehicles
        </a>

        <div class="vehicle-details-grid">
            <!-- Vehicle Images -->
            <div class="vehicle-images">
                <div class="main-image">
                    <c:choose>
                        <c:when test="${vehicle.imageUrl != null && !vehicle.imageUrl.isEmpty()}">
                            <img src="${pageContext.request.contextPath}/assets/images/${vehicle.imageUrl}"
                                 alt="${vehicle.vehicleName}"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/vehicles/default-vehicle.jpg'">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/images/vehicles/default-vehicle.jpg"
                                 alt="${vehicle.vehicleName}">
                        </c:otherwise>
                    </c:choose>
                    <span class="badge badge-${vehicle.availabilityStatus == 'Available' ? 'success' : 'danger'}">
                        ${vehicle.availabilityStatus}
                    </span>
                </div>

                <!-- Thumbnail gallery (if you have multiple images) -->
                <div class="thumbnail-gallery">
                    <c:choose>
                        <c:when test="${vehicle.imageUrl != null && !vehicle.imageUrl.isEmpty()}">
                            <img src="${pageContext.request.contextPath}/assets/images/${vehicle.imageUrl}" alt="View 1" class="thumbnail active">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/images/vehicles/default-vehicle.jpg" alt="View 1" class="thumbnail active">
                        </c:otherwise>
                    </c:choose>
                    <img src="${pageContext.request.contextPath}/assets/images/vehicles/default-vehicle.jpg" alt="View 2" class="thumbnail">
                    <img src="${pageContext.request.contextPath}/assets/images/vehicles/default-vehicle.jpg" alt="View 3" class="thumbnail">
                </div>
            </div>

            <!-- Vehicle Info -->
            <div class="vehicle-details-info">
                <div class="vehicle-header">
                    <h1>${vehicle.vehicleName}</h1>
                    <div class="vehicle-rating">
                        <c:forEach begin="1" end="5" var="i">
                            <i class="fas fa-star ${i <= avgRating ? 'active' : ''}"></i>
                        </c:forEach>
                        <span>(${avgRating} / 5.0) - ${reviewCount} reviews</span>
                    </div>
                </div>

                <div class="price-section">
                    <h2 class="price">$${vehicle.pricePerDay}<span>/day</span></h2>
                    <p class="price-note">*Inclusive of all taxes</p>
                </div>

                <div class="vehicle-specs">
                    <h3><i class="fas fa-info-circle"></i> Specifications</h3>
                    <div class="specs-grid">
                        <div class="spec-item">
                            <i class="fas fa-car"></i>
                            <div>
                                <span class="spec-label">Brand</span>
                                <span class="spec-value">${vehicle.brand}</span>
                            </div>
                        </div>

                        <div class="spec-item">
                            <i class="fas fa-tag"></i>
                            <div>
                                <span class="spec-label">Model</span>
                                <span class="spec-value">${vehicle.model}</span>
                            </div>
                        </div>

                        <div class="spec-item">
                            <i class="fas fa-calendar"></i>
                            <div>
                                <span class="spec-label">Year</span>
                                <span class="spec-value">${vehicle.year}</span>
                            </div>
                        </div>

                        <div class="spec-item">
                            <i class="fas fa-layer-group"></i>
                            <div>
                                <span class="spec-label">Category</span>
                                <span class="spec-value">${vehicle.category}</span>
                            </div>
                        </div>

                        <div class="spec-item">
                            <i class="fas fa-users"></i>
                            <div>
                                <span class="spec-label">Seating</span>
                                <span class="spec-value">${vehicle.seatingCapacity} Persons</span>
                            </div>
                        </div>

                        <div class="spec-item">
                            <i class="fas fa-cog"></i>
                            <div>
                                <span class="spec-label">Transmission</span>
                                <span class="spec-value">${vehicle.transmission}</span>
                            </div>
                        </div>

                        <div class="spec-item">
                            <i class="fas fa-gas-pump"></i>
                            <div>
                                <span class="spec-label">Fuel Type</span>
                                <span class="spec-value">${vehicle.fuelType}</span>
                            </div>
                        </div>

                        <div class="spec-item">
                            <i class="fas fa-palette"></i>
                            <div>
                                <span class="spec-label">Color</span>
                                <span class="spec-value">${vehicle.color}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="vehicle-features-section">
                    <h3><i class="fas fa-check-circle"></i> Features & Amenities</h3>
                    <div class="features-list">
                        <c:forEach items="${vehicle.features.split(',')}" var="feature">
                            <span class="feature-badge">
                                <i class="fas fa-check"></i> ${feature.trim()}
                            </span>
                        </c:forEach>
                    </div>
                </div>

                <div class="booking-section">
                    <c:choose>
                        <c:when test="${vehicle.availabilityStatus == 'Available'}">
                            <c:choose>
                                <c:when test="${sessionScope.loggedInUser != null}">
                                    <a href="${pageContext.request.contextPath}/createBooking?vehicleId=${vehicle.vehicleId}"
                                       class="btn btn-primary btn-large btn-block">
                                        <i class="fas fa-calendar-check"></i> Book This Vehicle
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-large btn-block">
                                        <i class="fas fa-sign-in-alt"></i> Login to Book
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-secondary btn-large btn-block" disabled>
                                <i class="fas fa-ban"></i> Currently Unavailable
                            </button>
                        </c:otherwise>
                    </c:choose>

                    <div class="booking-info">
                        <i class="fas fa-shield-alt"></i> Free cancellation up to 24 hours before pickup
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Reviews -->
        <div class="reviews-section">
            <h2><i class="fas fa-star"></i> Customer Reviews</h2>

            <c:choose>
                <c:when test="${feedbacks != null && feedbacks.size() > 0}">
                    <div class="reviews-grid">
                        <c:forEach items="${feedbacks}" var="feedback">
                            <div class="review-card">
                                <div class="review-header">
                                    <div class="reviewer-info">
                                        <i class="fas fa-user-circle"></i>
                                        <div>
                                            <h4>${feedback.isAnonymous ? 'Anonymous User' : feedback.userName}</h4>
                                            <small>${feedback.feedbackDate}</small>
                                        </div>
                                    </div>
                                    <div class="review-rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= feedback.rating ? 'active' : ''}"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                                <p class="review-comment">${feedback.comments}</p>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state-small">
                        <i class="fas fa-comment-slash"></i>
                        <p>No reviews yet. Be the first to review!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    // Thumbnail image gallery
    document.querySelectorAll('.thumbnail').forEach(thumb => {
        thumb.addEventListener('click', function() {
            document.querySelector('.thumbnail.active').classList.remove('active');
            this.classList.add('active');
            document.querySelector('.main-image img').src = this.src;
        });
    });
</script>

<%@ include file="../common/footer.jsp" %>
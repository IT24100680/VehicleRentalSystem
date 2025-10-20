<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../common/header.jsp" %>

<div class="page-header">
    <div class="container">
        <h1><i class="fas fa-car-side"></i> Available Vehicles</h1>
        <p>Choose from our premium collection</p>
    </div>
</div>

<div class="container">
    <!-- Filters -->
    <div class="filter-section">
        <div class="filter-card">
            <h3><i class="fas fa-filter"></i> Filter Vehicles</h3>
            <form action="${pageContext.request.contextPath}/vehicles" method="GET" class="filter-form">
                <div class="form-row">
                    <div class="form-group">
                        <label>Category</label>
                        <select name="category" class="form-control">
                            <option value="">All Categories</option>
                            <option value="Sedan">Sedan</option>
                            <option value="SUV">SUV</option>
                            <option value="Hatchback">Hatchback</option>
                            <option value="Luxury">Luxury</option>
                            <option value="Van">Van</option>
                            <option value="Truck">Truck</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Transmission</label>
                        <select name="transmission" class="form-control">
                            <option value="">Any</option>
                            <option value="Automatic">Automatic</option>
                            <option value="Manual">Manual</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Fuel Type</label>
                        <select name="fuelType" class="form-control">
                            <option value="">Any</option>
                            <option value="Petrol">Petrol</option>
                            <option value="Diesel">Diesel</option>
                            <option value="Electric">Electric</option>
                            <option value="Hybrid">Hybrid</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Price Range</label>
                        <select name="priceRange" class="form-control">
                            <option value="">Any Price</option>
                            <option value="0-50">$0 - $50</option>
                            <option value="50-100">$50 - $100</option>
                            <option value="100-150">$100 - $150</option>
                            <option value="150+">$150+</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Vehicle Grid -->
    <div class="vehicles-section">
        <div class="section-header">
            <h2>Showing ${vehicles != null ? vehicles.size() : 0} vehicles</h2>
            <div class="sort-options">
                <select class="form-control" onchange="sortVehicles(this.value)">
                    <option value="">Sort By</option>
                    <option value="price-low">Price: Low to High</option>
                    <option value="price-high">Price: High to Low</option>
                    <option value="rating">Highest Rated</option>
                    <option value="newest">Newest First</option>
                </select>
            </div>
        </div>

        <c:choose>
            <c:when test="${vehicles != null && vehicles.size() > 0}">
                <div class="vehicle-grid">
                    <c:forEach items="${vehicles}" var="vehicle">
                        <div class="vehicle-card animate__animated animate__fadeInUp">
                            <div class="vehicle-image">
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
                                <c:if test="${vehicle.category == 'Luxury'}">
                                    <span class="badge badge-premium">Premium</span>
                                </c:if>
                            </div>

                            <div class="vehicle-info">
                                <h3>${vehicle.vehicleName}</h3>
                                <p class="vehicle-description">${vehicle.brand} ${vehicle.model} - ${vehicle.year}</p>

                                <div class="vehicle-meta">
                                    <span><i class="fas fa-users"></i> ${vehicle.seatingCapacity} Seats</span>
                                    <span><i class="fas fa-cog"></i> ${vehicle.transmission}</span>
                                    <span><i class="fas fa-gas-pump"></i> ${vehicle.fuelType}</span>
                                </div>

                                <div class="vehicle-features">
                                    <c:forEach items="${vehicle.features.split(',')}" var="feature" begin="0" end="2">
                                        <span class="feature-tag"><i class="fas fa-check"></i> ${feature.trim()}</span>
                                    </c:forEach>
                                </div>

                                <div class="vehicle-footer">
                                    <div class="price">
                                        $${vehicle.pricePerDay}
                                        <span>/day</span>
                                    </div>
                                    <div class="vehicle-actions">
                                        <a href="${pageContext.request.contextPath}/viewVehicle?id=${vehicle.vehicleId}"
                                           class="btn btn-sm btn-outline">
                                            <i class="fas fa-info-circle"></i> Details
                                        </a>
                                        <c:if test="${vehicle.availabilityStatus == 'Available'}">
                                            <a href="${pageContext.request.contextPath}/createBooking?vehicleId=${vehicle.vehicleId}"
                                               class="btn btn-sm btn-primary">
                                                <i class="fas fa-calendar-plus"></i> Book Now
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-car-crash"></i>
                    <h3>No vehicles found</h3>
                    <p>Try adjusting your filters or check back later</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function sortVehicles(sortBy) {
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set('sort', sortBy);
        window.location.href = currentUrl.toString();
    }
</script>

<%@ include file="../common/footer.jsp" %>
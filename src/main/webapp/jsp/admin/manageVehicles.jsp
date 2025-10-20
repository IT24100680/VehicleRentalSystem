<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../common/header.jsp" %>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-car"></i> Manage Vehicles</h1>
            <button class="btn btn-primary" onclick="openAddVehicleModal()">
                <i class="fas fa-plus"></i> Add New Vehicle
            </button>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'added'}">Vehicle added successfully!</c:when>
                    <c:when test="${param.success == 'updated'}">Vehicle updated successfully!</c:when>
                    <c:when test="${param.success == 'deleted'}">Vehicle deleted successfully!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'delete'}">Failed to delete vehicle!</c:when>
                    <c:when test="${param.error == 'update'}">Failed to update vehicle!</c:when>
                    <c:when test="${param.error == 'notfound'}">Vehicle not found!</c:when>
                </c:choose>
            </div>
        </c:if>

        <!-- Stats Cards -->
        <div class="stats-grid" style="margin-bottom: 2rem;">
            <div class="stat-card stat-primary">
                <div class="stat-icon">
                    <i class="fas fa-car"></i>
                </div>
                <div class="stat-details">
                    <p>Total Vehicles</p>
                    <h2>${vehicles.size()}</h2>
                </div>
            </div>

            <div class="stat-card stat-success">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-details">
                    <p>Available</p>
                    <h2>
                        <c:set var="available" value="0"/>
                        <c:forEach items="${vehicles}" var="v">
                            <c:if test="${v.availabilityStatus == 'Available'}">
                                <c:set var="available" value="${available + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${available}
                    </h2>
                </div>
            </div>

            <div class="stat-card stat-warning">
                <div class="stat-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="stat-details">
                    <p>Booked</p>
                    <h2>
                        <c:set var="booked" value="0"/>
                        <c:forEach items="${vehicles}" var="v">
                            <c:if test="${v.availabilityStatus == 'Booked'}">
                                <c:set var="booked" value="${booked + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${booked}
                    </h2>
                </div>
            </div>
        </div>

        <!-- Vehicles Grid -->
        <div class="vehicles-admin-grid">
            <c:forEach items="${vehicles}" var="vehicle">
                <div class="vehicle-admin-card">
                    <div class="vehicle-admin-image">
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
                        <span class="badge badge-${
                            vehicle.availabilityStatus == 'Available' ? 'success' :
                            vehicle.availabilityStatus == 'Booked' ? 'warning' :
                            'danger'
                        }">
                                ${vehicle.availabilityStatus}
                        </span>
                    </div>

                    <div class="vehicle-admin-info">
                        <h3>${vehicle.vehicleName}</h3>
                        <p class="vehicle-model">${vehicle.brand} ${vehicle.model} - ${vehicle.year}</p>

                        <div class="vehicle-admin-specs">
                            <span><i class="fas fa-tag"></i> ${vehicle.category}</span>
                            <span><i class="fas fa-users"></i> ${vehicle.seatingCapacity} Seats</span>
                            <span><i class="fas fa-cog"></i> ${vehicle.transmission}</span>
                        </div>

                        <div class="vehicle-admin-price">
                            <strong>$${vehicle.pricePerDay}</strong>/day
                        </div>

                        <div class="vehicle-admin-actions">
                            <button class="btn btn-sm btn-info" onclick="viewVehicleDetails(${vehicle.vehicleId})">
                                <i class="fas fa-eye"></i> View
                            </button>
                            <button class="btn btn-sm btn-warning" onclick="editVehicle(${vehicle.vehicleId})">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <form action="${pageContext.request.contextPath}/admin/deleteVehicle" method="GET"
                                  style="display:inline;" onsubmit="return confirmDelete('Delete this vehicle?')">
                                <input type="hidden" name="id" value="${vehicle.vehicleId}">
                                <button type="submit" class="btn btn-sm btn-danger">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Add Vehicle Modal -->
<div id="addVehicleModal" class="modal">
    <div class="modal-content modal-large">
        <div class="modal-header">
            <h3><i class="fas fa-car"></i> Add New Vehicle</h3>
            <span class="close" onclick="closeAddVehicleModal()">&times;</span>
        </div>
        <form action="${pageContext.request.contextPath}/admin/addVehicle" method="POST">
            <div class="modal-body" style="padding: 1.5rem; max-height: 60vh; overflow-y: auto;">
            <div class="form-row">
                <div class="form-group">
                    <label for="vehicleName">Vehicle Name *</label>
                    <input type="text" id="vehicleName" name="vehicleName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="brand">Brand *</label>
                    <input type="text" id="brand" name="brand" class="form-control" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="model">Model *</label>
                    <input type="text" id="model" name="model" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="year">Year *</label>
                    <input type="number" id="year" name="year" class="form-control" required min="2000" max="2025">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="category">Category *</label>
                    <select id="category" name="category" class="form-control" required>
                        <option value="">Select Category</option>
                        <option value="Sedan">Sedan</option>
                        <option value="SUV">SUV</option>
                        <option value="Hatchback">Hatchback</option>
                        <option value="Luxury">Luxury</option>
                        <option value="Van">Van</option>
                        <option value="Truck">Truck</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="fuelType">Fuel Type *</label>
                    <select id="fuelType" name="fuelType" class="form-control" required>
                        <option value="">Select Fuel Type</option>
                        <option value="Petrol">Petrol</option>
                        <option value="Diesel">Diesel</option>
                        <option value="Electric">Electric</option>
                        <option value="Hybrid">Hybrid</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="transmission">Transmission *</label>
                    <select id="transmission" name="transmission" class="form-control" required>
                        <option value="">Select Transmission</option>
                        <option value="Manual">Manual</option>
                        <option value="Automatic">Automatic</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="seatingCapacity">Seating Capacity *</label>
                    <input type="number" id="seatingCapacity" name="seatingCapacity" class="form-control" required min="2" max="15">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="pricePerDay">Price Per Day ($) *</label>
                    <input type="number" id="pricePerDay" name="pricePerDay" class="form-control" required min="1" step="0.01">
                </div>

                <div class="form-group">
                    <label for="vehicleNumber">Vehicle Number *</label>
                    <input type="text" id="vehicleNumber" name="vehicleNumber" class="form-control" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="color">Color</label>
                    <input type="text" id="color" name="color" class="form-control">
                </div>

                <div class="form-group">
                    <label for="imageUrl">Image URL</label>
                    <input type="text" id="imageUrl" name="imageUrl" class="form-control"
                           placeholder="https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Vehicle+Image">
                </div>
            </div>

            <div class="form-group">
                <label for="features">Features</label>
                <textarea id="features" name="features" class="form-control" rows="3"
                          placeholder="GPS, Bluetooth, Backup Camera (comma separated)"></textarea>
            </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeAddVehicleModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Add Vehicle
                </button>
            </div>
        </form>
    </div>
</div>

<style>
    .vehicles-admin-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 2rem;
    }

    .vehicle-admin-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        overflow: hidden;
        transition: var(--transition);
    }

    .vehicle-admin-card:hover {
        box-shadow: var(--shadow-lg);
    }

    .vehicle-admin-image {
        position: relative;
        height: 200px;
        overflow: hidden;
    }

    .vehicle-admin-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .vehicle-admin-image .badge {
        position: absolute;
        top: 1rem;
        right: 1rem;
    }

    .vehicle-admin-info {
        padding: 1.5rem;
    }

    .vehicle-admin-info h3 {
        margin-bottom: 0.5rem;
    }

    .vehicle-model {
        color: var(--gray);
        margin-bottom: 1rem;
    }

    .vehicle-admin-specs {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
        margin-bottom: 1rem;
        font-size: 0.9rem;
        color: var(--gray);
    }

    .vehicle-admin-specs span {
        display: flex;
        align-items: center;
        gap: 0.3rem;
    }

    .vehicle-admin-price {
        font-size: 1.3rem;
        color: var(--primary-color);
        margin-bottom: 1rem;
    }

    .vehicle-admin-actions {
        display: flex;
        gap: 0.5rem;
        padding-top: 1rem;
        border-top: 2px solid var(--light);
    }

    .modal-large {
        max-width: 900px;
    }

    /* Modal Styles */
    .modal {
        display: none;
        position: fixed;
        z-index: 2000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
    }

    .modal-content {
        background-color: var(--white);
        margin: 2% auto;
        padding: 0;
        border-radius: var(--radius-lg);
        width: 90%;
        max-width: 600px;
        max-height: 90vh;
        overflow-y: auto;
        box-shadow: var(--shadow-xl);
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1.5rem;
        border-bottom: 2px solid var(--light);
    }

    .modal-header h3 {
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .close {
        font-size: 2rem;
        font-weight: bold;
        cursor: pointer;
        color: var(--gray);
    }

    .close:hover {
        color: var(--danger-color);
    }

    .modal-actions {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        padding: 1.5rem;
        border-top: 2px solid var(--light);
    }
</style>

<script>
    function openAddVehicleModal() {
        document.getElementById('addVehicleModal').style.display = 'block';
    }

    function closeAddVehicleModal() {
        document.getElementById('addVehicleModal').style.display = 'none';
    }

    function viewVehicleDetails(vehicleId) {
        window.location.href = '${pageContext.request.contextPath}/viewVehicle?id=' + vehicleId;
    }

    function editVehicle(vehicleId) {
        // For now, redirect to a separate edit page
        window.location.href = '${pageContext.request.contextPath}/admin/editVehicle?id=' + vehicleId;
    }

    // Close modal when clicking outside of it
    window.onclick = function(event) {
        const modal = document.getElementById('addVehicleModal');
        if (event.target == modal) {
            closeAddVehicleModal();
        }
    }

    // Close modal with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeAddVehicleModal();
        }
    });
</script>

<%@ include file="../common/footer.jsp" %>
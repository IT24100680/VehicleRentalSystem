<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../common/header.jsp" %>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-edit"></i> Edit Vehicle</h1>
            <a href="${pageContext.request.contextPath}/admin/manageVehicles" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Manage Vehicles
            </a>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'update'}">Failed to update vehicle!</c:when>
                    <c:when test="${param.error == 'notfound'}">Vehicle not found!</c:when>
                </c:choose>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-car"></i> Edit Vehicle Details</h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/updateVehicle" method="POST">
                    <input type="hidden" name="vehicleId" value="${vehicle.vehicleId}">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="vehicleName">Vehicle Name *</label>
                            <input type="text" id="vehicleName" name="vehicleName" class="form-control" 
                                   value="${vehicle.vehicleName}" required>
                        </div>

                        <div class="form-group">
                            <label for="brand">Brand *</label>
                            <input type="text" id="brand" name="brand" class="form-control" 
                                   value="${vehicle.brand}" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="model">Model *</label>
                            <input type="text" id="model" name="model" class="form-control" 
                                   value="${vehicle.model}" required>
                        </div>

                        <div class="form-group">
                            <label for="year">Year *</label>
                            <input type="number" id="year" name="year" class="form-control" 
                                   value="${vehicle.year}" required min="2000" max="2025">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="category">Category *</label>
                            <select id="category" name="category" class="form-control" required>
                                <option value="">Select Category</option>
                                <option value="Sedan" ${vehicle.category == 'Sedan' ? 'selected' : ''}>Sedan</option>
                                <option value="SUV" ${vehicle.category == 'SUV' ? 'selected' : ''}>SUV</option>
                                <option value="Hatchback" ${vehicle.category == 'Hatchback' ? 'selected' : ''}>Hatchback</option>
                                <option value="Luxury" ${vehicle.category == 'Luxury' ? 'selected' : ''}>Luxury</option>
                                <option value="Van" ${vehicle.category == 'Van' ? 'selected' : ''}>Van</option>
                                <option value="Truck" ${vehicle.category == 'Truck' ? 'selected' : ''}>Truck</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="fuelType">Fuel Type *</label>
                            <select id="fuelType" name="fuelType" class="form-control" required>
                                <option value="">Select Fuel Type</option>
                                <option value="Petrol" ${vehicle.fuelType == 'Petrol' ? 'selected' : ''}>Petrol</option>
                                <option value="Diesel" ${vehicle.fuelType == 'Diesel' ? 'selected' : ''}>Diesel</option>
                                <option value="Electric" ${vehicle.fuelType == 'Electric' ? 'selected' : ''}>Electric</option>
                                <option value="Hybrid" ${vehicle.fuelType == 'Hybrid' ? 'selected' : ''}>Hybrid</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="transmission">Transmission *</label>
                            <select id="transmission" name="transmission" class="form-control" required>
                                <option value="">Select Transmission</option>
                                <option value="Manual" ${vehicle.transmission == 'Manual' ? 'selected' : ''}>Manual</option>
                                <option value="Automatic" ${vehicle.transmission == 'Automatic' ? 'selected' : ''}>Automatic</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="seatingCapacity">Seating Capacity *</label>
                            <input type="number" id="seatingCapacity" name="seatingCapacity" class="form-control" 
                                   value="${vehicle.seatingCapacity}" required min="2" max="15">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="pricePerDay">Price Per Day ($) *</label>
                            <input type="number" id="pricePerDay" name="pricePerDay" class="form-control" 
                                   value="${vehicle.pricePerDay}" required min="1" step="0.01">
                        </div>

                        <div class="form-group">
                            <label for="vehicleNumber">Vehicle Number *</label>
                            <input type="text" id="vehicleNumber" name="vehicleNumber" class="form-control" 
                                   value="${vehicle.vehicleNumber}" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="color">Color</label>
                            <input type="text" id="color" name="color" class="form-control" 
                                   value="${vehicle.color}">
                        </div>

                        <div class="form-group">
                            <label for="imageUrl">Image URL</label>
                            <input type="text" id="imageUrl" name="imageUrl" class="form-control"
                                   value="${vehicle.imageUrl}" placeholder="https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Vehicle+Image">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="availabilityStatus">Availability Status *</label>
                            <select id="availabilityStatus" name="availabilityStatus" class="form-control" required>
                                <option value="Available" ${vehicle.availabilityStatus == 'Available' ? 'selected' : ''}>Available</option>
                                <option value="Booked" ${vehicle.availabilityStatus == 'Booked' ? 'selected' : ''}>Booked</option>
                                <option value="Maintenance" ${vehicle.availabilityStatus == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="features">Features</label>
                        <textarea id="features" name="features" class="form-control" rows="3"
                                  placeholder="GPS, Bluetooth, Backup Camera (comma separated)">${vehicle.features}</textarea>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/manageVehicles" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Vehicle
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
</style>

<%@ include file="../common/footer.jsp" %>

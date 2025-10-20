<%@ include file="../common/header.jsp" %>

<div class="booking-container">
    <div class="container">
        <h1><i class="fas fa-calendar-plus"></i> Create Booking</h1>

        <div class="booking-layout">
            <!-- Booking Form -->
            <div class="booking-form-section">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-file-alt"></i> Booking Details</h3>
                    </div>

                    <c:if test="${errorMessage != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/createBooking" method="POST"
                          onsubmit="return validateBooking()" class="booking-form">

                        <input type="hidden" name="vehicleId" value="${vehicle.vehicleId}">

                        <div class="form-row">
                            <div class="form-group">
                                <label for="startDate">
                                    <i class="fas fa-calendar-alt"></i> Pickup Date *
                                </label>
                                <input type="date" id="startDate" name="startDate" class="form-control"
                                       required min="${java.time.LocalDate.now()}"
                                       onchange="calculateTotal()">
                            </div>

                            <div class="form-group">
                                <label for="endDate">
                                    <i class="fas fa-calendar-alt"></i> Return Date *
                                </label>
                                <input type="date" id="endDate" name="endDate" class="form-control"
                                       required min="${java.time.LocalDate.now()}"
                                       onchange="calculateTotal()">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="pickupLocation">
                                    <i class="fas fa-map-marker-alt"></i> Pickup Location *
                                </label>
                                <select id="pickupLocation" name="pickupLocation" class="form-control" required>
                                    <option value="">Select City</option>
                                    <option value="Colombo">Colombo</option>
                                    <option value="Kandy">Kandy</option>
                                    <option value="Galle">Galle</option>
                                    <option value="Jaffna">Jaffna</option>
                                    <option value="Negombo">Negombo</option>
                                    <option value="Anuradhapura">Anuradhapura</option>
                                    <option value="Polonnaruwa">Polonnaruwa</option>
                                    <option value="Trincomalee">Trincomalee</option>
                                    <option value="Batticaloa">Batticaloa</option>
                                    <option value="Matara">Matara</option>
                                    <option value="Kurunegala">Kurunegala</option>
                                    <option value="Ratnapura">Ratnapura</option>
                                    <option value="Badulla">Badulla</option>
                                    <option value="Nuwara Eliya">Nuwara Eliya</option>
                                    <option value="Gampaha">Gampaha</option>
                                    <option value="Kalutara">Kalutara</option>
                                    <option value="Kegalle">Kegalle</option>
                                    <option value="Puttalam">Puttalam</option>
                                    <option value="Monaragala">Monaragala</option>
                                    <option value="Hambantota">Hambantota</option>
                                    <option value="Matale">Matale</option>
                                    <option value="Kilinochchi">Kilinochchi</option>
                                    <option value="Mannar">Mannar</option>
                                    <option value="Vavuniya">Vavuniya</option>
                                    <option value="Ampara">Ampara</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="dropoffLocation">
                                    <i class="fas fa-map-marker-alt"></i> Drop-off Location *
                                </label>
                                <select id="dropoffLocation" name="dropoffLocation" class="form-control" required>
                                    <option value="">Select City</option>
                                    <option value="Colombo">Colombo</option>
                                    <option value="Kandy">Kandy</option>
                                    <option value="Galle">Galle</option>
                                    <option value="Jaffna">Jaffna</option>
                                    <option value="Negombo">Negombo</option>
                                    <option value="Anuradhapura">Anuradhapura</option>
                                    <option value="Polonnaruwa">Polonnaruwa</option>
                                    <option value="Trincomalee">Trincomalee</option>
                                    <option value="Batticaloa">Batticaloa</option>
                                    <option value="Matara">Matara</option>
                                    <option value="Kurunegala">Kurunegala</option>
                                    <option value="Ratnapura">Ratnapura</option>
                                    <option value="Badulla">Badulla</option>
                                    <option value="Nuwara Eliya">Nuwara Eliya</option>
                                    <option value="Gampaha">Gampaha</option>
                                    <option value="Kalutara">Kalutara</option>
                                    <option value="Kegalle">Kegalle</option>
                                    <option value="Puttalam">Puttalam</option>
                                    <option value="Monaragala">Monaragala</option>
                                    <option value="Hambantota">Hambantota</option>
                                    <option value="Matale">Matale</option>
                                    <option value="Kilinochchi">Kilinochchi</option>
                                    <option value="Mannar">Mannar</option>
                                    <option value="Vavuniya">Vavuniya</option>
                                    <option value="Ampara">Ampara</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="specialRequests">
                                <i class="fas fa-comment-dots"></i> Special Requests (Optional)
                            </label>
                            <textarea id="specialRequests" name="specialRequests" class="form-control"
                                      rows="4" placeholder="Any special requirements or requests..."></textarea>
                        </div>

                        <div class="booking-summary">
                            <h4><i class="fas fa-calculator"></i> Booking Summary</h4>
                            <div class="summary-row">
                                <span>Price per day:</span>
                                <span class="price-value">$${vehicle.pricePerDay}</span>
                            </div>
                            <div class="summary-row">
                                <span>Number of days:</span>
                                <span id="totalDays">0</span>
                            </div>
                            <div class="summary-row total">
                                <span>Total Amount:</span>
                                <span class="total-value" id="totalAmount">$0.00</span>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/viewVehicle?id=${vehicle.vehicleId}"
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-check"></i> Confirm Booking
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Vehicle Summary -->
            <div class="booking-sidebar">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-car"></i> Selected Vehicle</h3>
                    </div>
                    <div class="vehicle-summary">
                        <img src="${pageContext.request.contextPath}/${vehicle.imageUrl}"
                             alt="${vehicle.vehicleName}">
                        <h3>${vehicle.vehicleName}</h3>
                        <p>${vehicle.brand} ${vehicle.model}</p>

                        <div class="vehicle-quick-specs">
                            <span><i class="fas fa-users"></i> ${vehicle.seatingCapacity}</span>
                            <span><i class="fas fa-cog"></i> ${vehicle.transmission}</span>
                            <span><i class="fas fa-gas-pump"></i> ${vehicle.fuelType}</span>
                        </div>

                        <div class="price-info">
                            <span class="price-label">Daily Rate:</span>
                            <span class="price">$${vehicle.pricePerDay}/day</span>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-info-circle"></i> Important Information</h3>
                    </div>
                    <ul class="info-list">
                        <li><i class="fas fa-check"></i> Valid driver's license required</li>
                        <li><i class="fas fa-check"></i> Minimum age: 21 years</li>
                        <li><i class="fas fa-check"></i> Insurance included</li>
                        <li><i class="fas fa-check"></i> Free cancellation (24hrs notice)</li>
                        <li><i class="fas fa-check"></i> Fuel policy: Full to Full</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const pricePerDay = ${vehicle.pricePerDay};

    function calculateTotal() {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        if (startDate && endDate) {
            const start = new Date(startDate);
            const end = new Date(endDate);
            const diffTime = Math.abs(end - start);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

            // For same-day bookings, minimum 1 day
            const totalDays = diffDays >= 0 ? diffDays + 1 : 1;
            const totalAmount = totalDays * pricePerDay;

            document.getElementById('totalDays').textContent = totalDays;
            document.getElementById('totalAmount').textContent = '$' + totalAmount.toFixed(2);
        }
    }

    function validateBooking() {
        const startDate = new Date(document.getElementById('startDate').value);
        const endDate = new Date(document.getElementById('endDate').value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        if (startDate < today) {
            alert('Pickup date cannot be in the past!');
            return false;
        }

        if (endDate < startDate) {
            alert('Return date must be on or after pickup date!');
            return false;
        }

        return true;
    }
</script>

<%@ include file="../common/footer.jsp" %>
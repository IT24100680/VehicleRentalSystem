<%@ include file="../common/header.jsp" %>

<div class="auth-container">
    <div class="auth-box auth-box-large animate__animated animate__fadeInDown">
        <div class="auth-header">
            <i class="fas fa-user-plus"></i>
            <h2>Create Account</h2>
            <p>Join us today and start renting!</p>
        </div>

        <c:if test="${errorMessage != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                    ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="POST" class="auth-form"
              onsubmit="return validateRegistration()">

            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">
                        <i class="fas fa-user"></i> Full Name *
                    </label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required
                           placeholder="John Doe">
                </div>

                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i> Email Address *
                    </label>
                    <input type="email" id="email" name="email" class="form-control" required
                           placeholder="john@example.com">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="phone">
                        <i class="fas fa-phone"></i> Phone Number
                    </label>
                    <input type="tel" id="phone" name="phone" class="form-control"
                           placeholder="1234567890" pattern="[0-9]{10}">
                </div>

                <div class="form-group">
                    <label for="dateOfBirth">
                        <i class="fas fa-calendar"></i> Date of Birth
                    </label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label for="address">
                    <i class="fas fa-map-marker-alt"></i> Address
                </label>
                <input type="text" id="address" name="address" class="form-control"
                       placeholder="Street Address">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="city">
                        <i class="fas fa-city"></i> City
                    </label>
                    <input type="text" id="city" name="city" class="form-control" placeholder="City">
                </div>

                <div class="form-group">
                    <label for="state">
                        <i class="fas fa-map"></i> State
                    </label>
                    <input type="text" id="state" name="state" class="form-control" placeholder="State">
                </div>

                <div class="form-group">
                    <label for="zipCode">
                        <i class="fas fa-mail-bulk"></i> Zip Code
                    </label>
                    <input type="text" id="zipCode" name="zipCode" class="form-control"
                           placeholder="12345">
                </div>
            </div>

            <div class="form-group">
                <label for="licenseNumber">
                    <i class="fas fa-id-card"></i> License Number
                </label>
                <input type="text" id="licenseNumber" name="licenseNumber" class="form-control"
                       placeholder="DL123456789">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i> Password *
                    </label>
                    <input type="password" id="password" name="password" class="form-control" required
                           placeholder="Minimum 8 characters">
                    <small class="form-text">Must contain at least 8 characters with letters and numbers</small>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-lock"></i> Confirm Password *
                    </label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           class="form-control" required placeholder="Re-enter password">
                </div>
            </div>

            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" name="terms" required>
                    <span>I agree to the <a href="#">Terms & Conditions</a> and <a href="#">Privacy Policy</a></span>
                </label>
            </div>

            <button type="submit" class="btn btn-primary btn-block">
                <i class="fas fa-user-plus"></i> Create Account
            </button>
        </form>

        <div class="auth-footer">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
        </div>
    </div>
</div>

<script>
    function validateRegistration() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            alert('Passwords do not match!');
            return false;
        }

        if (password.length < 8) {
            alert('Password must be at least 8 characters long!');
            return false;
        }

        return true;
    }
</script>

<%@ include file="../common/footer.jsp" %>
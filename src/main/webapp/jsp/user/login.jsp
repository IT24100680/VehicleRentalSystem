<%@ include file="../common/header.jsp" %>

<div class="auth-container">
    <div class="auth-box animate__animated animate__fadeInDown">
        <div class="auth-header">
            <i class="fas fa-sign-in-alt"></i>
            <h2>Welcome Back</h2>
            <p>Login to your account</p>
        </div>

        <c:if test="${param.success == 'registered'}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                Registration successful! Please login.
            </div>
        </c:if>

        <c:if test="${param.logout == 'success'}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                You have been logged out successfully.
            </div>
        </c:if>

        <c:if test="${param.deactivated == 'true'}">
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                Your account has been deactivated.
            </div>
        </c:if>

        <c:if test="${errorMessage != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                    ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST" class="auth-form">
            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope"></i> Email Address
                </label>
                <input type="email" id="email" name="email" class="form-control" required
                       placeholder="Enter your email">
            </div>

            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock"></i> Password
                </label>
                <div class="password-input">
                    <input type="password" id="password" name="password" class="form-control" required
                           placeholder="Enter your password">
                    <i class="fas fa-eye toggle-password" onclick="togglePassword()"></i>
                </div>
            </div>

            <div class="form-options">
                <label class="checkbox-label">
                    <input type="checkbox" name="remember">
                    <span>Remember me</span>
                </label>
                <a href="#" class="forgot-password">Forgot Password?</a>
            </div>

            <button type="submit" class="btn btn-primary btn-block">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>
        </form>

        <div class="auth-footer">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
        </div>
    </div>
</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.querySelector('.toggle-password');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }
</script>

<%@ include file="../common/footer.jsp" %>
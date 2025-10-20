<!-- FILE: src/main/webapp/jsp/user/changePassword.jsp -->

<%@ include file="../common/header.jsp" %>

<div class="change-password-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/profile" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Profile
        </a>

        <div class="change-password-box">
            <div class="card">
                <div class="card-header">
                    <h2><i class="fas fa-key"></i> Change Password</h2>
                    <p>Keep your account secure with a strong password</p>
                </div>

                <div class="card-body">
                    <c:if test="${errorMessage != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/changePassword" method="POST"
                          onsubmit="return validatePasswordChange()" class="password-form">

                        <div class="form-group">
                            <label for="currentPassword">
                                <i class="fas fa-lock"></i> Current Password *
                            </label>
                            <div class="password-input">
                                <input type="password" id="currentPassword" name="currentPassword"
                                       class="form-control" required placeholder="Enter current password">
                                <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('currentPassword')"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="newPassword">
                                <i class="fas fa-lock"></i> New Password *
                            </label>
                            <div class="password-input">
                                <input type="password" id="newPassword" name="newPassword"
                                       class="form-control" required placeholder="Enter new password"
                                       onkeyup="checkPasswordStrength()">
                                <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('newPassword')"></i>
                            </div>
                            <div id="passwordStrength" class="password-strength"></div>
                            <small class="form-text">Minimum 8 characters with letters and numbers</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">
                                <i class="fas fa-lock"></i> Confirm New Password *
                            </label>
                            <div class="password-input">
                                <input type="password" id="confirmPassword" name="confirmPassword"
                                       class="form-control" required placeholder="Re-enter new password">
                                <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('confirmPassword')"></i>
                            </div>
                        </div>

                        <div class="password-tips">
                            <h4><i class="fas fa-shield-alt"></i> Password Security Tips</h4>
                            <ul>
                                <li>Use at least 8 characters</li>
                                <li>Include uppercase and lowercase letters</li>
                                <li>Add numbers and special characters</li>
                                <li>Avoid common words or patterns</li>
                                <li>Don't reuse passwords from other sites</li>
                            </ul>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Change Password
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .change-password-container {
        padding: 3rem 0;
    }

    .change-password-box {
        max-width: 600px;
        margin: 2rem auto;
    }

    .password-strength {
        height: 5px;
        margin-top: 0.5rem;
        border-radius: 3px;
        transition: var(--transition);
    }

    .password-strength.weak {
        background: var(--danger-color);
        width: 33%;
    }

    .password-strength.medium {
        background: var(--warning-color);
        width: 66%;
    }

    .password-strength.strong {
        background: var(--success-color);
        width: 100%;
    }

    .password-tips {
        background: var(--light);
        padding: 1.5rem;
        border-radius: var(--radius-md);
        margin: 1.5rem 0;
        border-left: 4px solid var(--info-color);
    }

    .password-tips h4 {
        color: var(--info-color);
        margin-bottom: 1rem;
        font-size: 1rem;
    }

    .password-tips ul {
        margin-left: 1.5rem;
    }

    .password-tips li {
        margin-bottom: 0.5rem;
        color: var(--dark);
    }
</style>

<script>
    function togglePasswordVisibility(inputId) {
        const input = document.getElementById(inputId);
        const icon = input.nextElementSibling;

        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    function checkPasswordStrength() {
        const password = document.getElementById('newPassword').value;
        const strengthBar = document.getElementById('passwordStrength');

        let strength = 0;
        if (password.length >= 8) strength++;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^a-zA-Z0-9]/.test(password)) strength++;

        strengthBar.className = 'password-strength';
        if (strength <= 2) {
            strengthBar.classList.add('weak');
        } else if (strength === 3) {
            strengthBar.classList.add('medium');
        } else {
            strengthBar.classList.add('strong');
        }
    }

    function validatePasswordChange() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword !== confirmPassword) {
            alert('New passwords do not match!');
            return false;
        }

        if (newPassword.length < 8) {
            alert('Password must be at least 8 characters long!');
            return false;
        }

        if (!/[A-Za-z]/.test(newPassword) || !/[0-9]/.test(newPassword)) {
            alert('Password must contain both letters and numbers!');
            return false;
        }

        return confirm('Are you sure you want to change your password?');
    }
</script>

<%@ include file="../common/footer.jsp" %>
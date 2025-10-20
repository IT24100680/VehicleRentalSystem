<%@ include file="../common/header.jsp" %>

<div class="profile-container">
    <div class="container">
        <div class="profile-header">
            <h1><i class="fas fa-user-circle"></i> My Profile</h1>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'updated'}">Profile updated successfully!</c:when>
                    <c:when test="${param.success == 'password'}">Password changed successfully!</c:when>
                </c:choose>
            </div>
        </c:if>

        <div class="profile-layout">
            <!-- Profile Sidebar -->
            <div class="profile-sidebar">
                <div class="profile-card">
                    <div class="profile-avatar">
                        <img src="${pageContext.request.contextPath}/assets/images/user-avatar-${user.userId % 6 + 1}.jpg" 
                             alt="${user.fullName}" 
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                        <i class="fas fa-user-circle" style="display:none;"></i>
                    </div>
                    <h2>${user.fullName}</h2>
                    <p class="user-email">${user.email}</p>
                    <span class="badge badge-${user.role == 'ADMIN' ? 'danger' : 'primary'}">
                        ${user.role}
                    </span>

                    <div class="profile-stats">
                        <div class="stat">
                            <strong>Member Since</strong>
                            <span>${user.createdAt}</span>
                        </div>
                        <div class="stat">
                            <strong>Status</strong>
                            <span class="badge badge-${user.active ? 'success' : 'danger'}">
                                ${user.active ? 'Active' : 'Inactive'}
                            </span>
                        </div>
                    </div>

                    <div class="profile-actions">
                        <a href="${pageContext.request.contextPath}/updateProfile" class="btn btn-primary btn-block">
                            <i class="fas fa-edit"></i> Edit Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/changePassword" class="btn btn-warning btn-block">
                            <i class="fas fa-key"></i> Change Password
                        </a>
                    </div>
                </div>
            </div>

            <!-- Profile Details -->
            <div class="profile-main">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-info-circle"></i> Personal Information</h3>
                    </div>
                    <div class="card-body">
                        <div class="info-grid">
                            <div class="info-item">
                                <label><i class="fas fa-user"></i> Full Name</label>
                                <p>${user.fullName}</p>
                            </div>

                            <div class="info-item">
                                <label><i class="fas fa-envelope"></i> Email Address</label>
                                <p>${user.email}</p>
                            </div>

                            <div class="info-item">
                                <label><i class="fas fa-phone"></i> Phone Number</label>
                                <p>${user.phone != null ? user.phone : 'Not provided'}</p>
                            </div>

                            <div class="info-item">
                                <label><i class="fas fa-calendar"></i> Date of Birth</label>
                                <p>${user.dateOfBirth != null ? user.dateOfBirth : 'Not provided'}</p>
                            </div>

                            <div class="info-item">
                                <label><i class="fas fa-id-card"></i> License Number</label>
                                <p>${user.licenseNumber != null ? user.licenseNumber : 'Not provided'}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-map-marker-alt"></i> Address Information</h3>
                    </div>
                    <div class="card-body">
                        <div class="info-grid">
                            <div class="info-item">
                                <label><i class="fas fa-home"></i> Street Address</label>
                                <p>${user.address != null ? user.address : 'Not provided'}</p>
                            </div>

                            <div class="info-item">
                                <label><i class="fas fa-city"></i> City</label>
                                <p>${user.city != null ? user.city : 'Not provided'}</p>
                            </div>

                            <div class="info-item">
                                <label><i class="fas fa-map"></i> State</label>
                                <p>${user.state != null ? user.state : 'Not provided'}</p>
                            </div>

                            <div class="info-item">
                                <label><i class="fas fa-mail-bulk"></i> Zip Code</label>
                                <p>${user.zipCode != null ? user.zipCode : 'Not provided'}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card danger-zone">
                    <div class="card-header">
                        <h3><i class="fas fa-exclamation-triangle"></i> Danger Zone</h3>
                    </div>
                    <div class="card-body">
                        <p>Once you deactivate your account, you will lose access to all services.</p>
                        <button class="btn btn-danger" onclick="confirmDeactivate()">
                            <i class="fas fa-user-times"></i> Deactivate Account
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Deactivation Modal -->
<div id="deactivateModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-exclamation-triangle"></i> Confirm Account Deactivation</h3>
            <span class="close" onclick="closeDeactivateModal()">&times;</span>
        </div>
        <div style="padding: 1.5rem;">
            <p><strong>Warning:</strong> This action will deactivate your account. You will lose access to:</p>
            <ul style="margin: 1rem 0; padding-left: 2rem;">
                <li>All active bookings</li>
                <li>Payment history</li>
                <li>Support tickets</li>
                <li>Your reviews and feedback</li>
            </ul>
            <p>Are you absolutely sure you want to proceed?</p>

            <form action="${pageContext.request.contextPath}/deactivateUser" method="POST">
                <div class="form-group">
                    <label class="checkbox-label">
                        <input type="checkbox" name="confirmDeactivate" value="YES" required>
                        <span>I understand and want to deactivate my account</span>
                    </label>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeDeactivateModal()">Cancel</button>
                    <button type="submit" class="btn btn-danger">Deactivate Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .profile-container {
        padding: 3rem 0;
    }

    .profile-header {
        margin-bottom: 2rem;
    }

    .profile-layout {
        display: grid;
        grid-template-columns: 350px 1fr;
        gap: 2rem;
    }

    .profile-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        padding: 2rem;
        text-align: center;
    }

    .profile-avatar {
        font-size: 6rem;
        color: var(--primary-color);
        margin-bottom: 1rem;
        position: relative;
    }
    
    .profile-avatar img {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid var(--primary-color);
    }

    .profile-card h2 {
        margin-bottom: 0.5rem;
    }

    .user-email {
        color: var(--gray);
        margin-bottom: 1rem;
    }

    .profile-stats {
        margin: 2rem 0;
        padding: 1.5rem;
        background: var(--light);
        border-radius: var(--radius-md);
    }

    .profile-stats .stat {
        margin-bottom: 1rem;
    }

    .profile-stats .stat:last-child {
        margin-bottom: 0;
    }

    .profile-stats strong {
        display: block;
        color: var(--gray);
        font-size: 0.9rem;
        margin-bottom: 0.3rem;
    }

    .profile-actions {
        margin-top: 1.5rem;
    }

    .profile-actions .btn {
        margin-bottom: 0.5rem;
    }

    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1.5rem;
    }

    .info-item label {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: var(--gray);
        font-size: 0.9rem;
        margin-bottom: 0.5rem;
        font-weight: 600;
    }

    .info-item p {
        color: var(--dark);
        font-size: 1.1rem;
    }

    .danger-zone {
        border: 2px solid var(--danger-color);
    }

    .danger-zone .card-header {
        background: var(--danger-color);
        color: var(--white);
    }

    @media (max-width: 768px) {
        .profile-layout {
            grid-template-columns: 1fr;
        }
    }
</style>

<script>
    function confirmDeactivate() {
        document.getElementById('deactivateModal').style.display = 'block';
    }

    function closeDeactivateModal() {
        document.getElementById('deactivateModal').style.display = 'none';
    }
</script>

<%@ include file="../common/footer.jsp" %>
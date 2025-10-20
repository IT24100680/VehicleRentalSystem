<!-- FILE: src/main/webapp/jsp/user/editProfile.jsp -->

<%@ include file="../common/header.jsp" %>

<div class="edit-profile-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/profile" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Profile
        </a>

        <div class="edit-profile-box">
            <div class="card">
                <div class="card-header">
                    <h2><i class="fas fa-user-edit"></i> Edit Profile</h2>
                </div>

                <div class="card-body">
                    <c:if test="${errorMessage != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/updateProfile" method="POST" class="edit-form">
                        <h3><i class="fas fa-user"></i> Personal Information</h3>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="fullName">
                                    <i class="fas fa-user"></i> Full Name *
                                </label>
                                <input type="text" id="fullName" name="fullName" class="form-control"
                                       required value="${user.fullName}">
                            </div>

                            <div class="form-group">
                                <label for="phone">
                                    <i class="fas fa-phone"></i> Phone Number
                                </label>
                                <input type="tel" id="phone" name="phone" class="form-control"
                                       value="${user.phone}" pattern="[0-9]{10}">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="dateOfBirth">
                                    <i class="fas fa-calendar"></i> Date of Birth
                                </label>
                                <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control"
                                       value="${user.dateOfBirth}">
                            </div>

                            <div class="form-group">
                                <label for="licenseNumber">
                                    <i class="fas fa-id-card"></i> License Number
                                </label>
                                <input type="text" id="licenseNumber" name="licenseNumber" class="form-control"
                                       value="${user.licenseNumber}">
                            </div>
                        </div>

                        <hr>

                        <h3><i class="fas fa-map-marker-alt"></i> Address Information</h3>

                        <div class="form-group">
                            <label for="address">
                                <i class="fas fa-home"></i> Street Address
                            </label>
                            <input type="text" id="address" name="address" class="form-control"
                                   value="${user.address}" placeholder="123 Main Street">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="city">
                                    <i class="fas fa-city"></i> City
                                </label>
                                <input type="text" id="city" name="city" class="form-control"
                                       value="${user.city}">
                            </div>

                            <div class="form-group">
                                <label for="state">
                                    <i class="fas fa-map"></i> State
                                </label>
                                <input type="text" id="state" name="state" class="form-control"
                                       value="${user.state}">
                            </div>

                            <div class="form-group">
                                <label for="zipCode">
                                    <i class="fas fa-mail-bulk"></i> Zip Code
                                </label>
                                <input type="text" id="zipCode" name="zipCode" class="form-control"
                                       value="${user.zipCode}">
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .edit-profile-container {
        padding: 3rem 0;
    }

    .edit-profile-box {
        max-width: 900px;
        margin: 2rem auto;
    }

    .edit-form h3 {
        margin: 1.5rem 0 1rem;
        color: var(--dark);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .edit-form h3:first-of-type {
        margin-top: 0;
    }

    .edit-form hr {
        margin: 2rem 0;
        border: none;
        border-top: 2px solid var(--light);
    }
</style>

<%@ include file="../common/footer.jsp" %>
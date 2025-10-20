<!-- FILE: src/main/webapp/jsp/admin/manageUsers.jsp -->

<%@ include file="../common/header.jsp" %>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-users"></i> Manage Users</h1>
            <button class="btn btn-primary" onclick="openAddUserModal()">
                <i class="fas fa-user-plus"></i> Add New User
            </button>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'added'}">User added successfully!</c:when>
                    <c:when test="${param.success == 'updated'}">User updated successfully!</c:when>
                    <c:when test="${param.success == 'deleted'}">User deleted successfully!</c:when>
                    <c:when test="${param.success == 'activated'}">User activated successfully!</c:when>
                    <c:when test="${param.success == 'deactivated'}">User deactivated successfully!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'add'}">Failed to add user!</c:when>
                    <c:when test="${param.error == 'update'}">Failed to update user!</c:when>
                    <c:when test="${param.error == 'delete'}">Failed to delete user!</c:when>
                    <c:otherwise>An error occurred!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Search and Filter -->
        <div class="admin-toolbar">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="userSearch" placeholder="Search users..." onkeyup="searchUsers()">
            </div>
            <div class="filter-group">
                <select id="roleFilter" onchange="filterUsers()" class="form-control">
                    <option value="">All Roles</option>
                    <option value="CUSTOMER">Customers</option>
                    <option value="ADMIN">Admins</option>
                </select>
                <select id="statusFilter" onchange="filterUsers()" class="form-control">
                    <option value="">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>
            </div>
        </div>

        <!-- Users Table -->
        <div class="table-responsive">
            <c:choose>
                <c:when test="${users != null && users.size() > 0}">
                    <table class="table" id="usersTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Joined</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${users}" var="user">
                            <tr data-role="${user.role}" data-status="${user.active ? 'active' : 'inactive'}">
                                <td><strong>#${user.userId}</strong></td>
                                <td>
                                    <div class="user-info">
                                        <i class="fas fa-user-circle user-avatar"></i>
                                        <span>${user.fullName}</span>
                                    </div>
                                </td>
                                <td>${user.email}</td>
                                <td>${user.phone != null ? user.phone : 'N/A'}</td>
                                <td>
                                        <span class="badge badge-${user.role == 'ADMIN' ? 'danger' : 'primary'}">
                                                ${user.role}
                                        </span>
                                </td>
                                <td>
                                        <span class="badge badge-${user.active ? 'success' : 'secondary'}">
                                                ${user.active ? 'Active' : 'Inactive'}
                                        </span>
                                </td>
                                <td>${user.createdAt}</td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-info" onclick="viewUser(${user.userId})" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-warning" onclick="editUser(${user.userId}, '${user.fullName}', '${user.phone}', '${user.address}', '${user.city}', '${user.state}', '${user.zipCode}')" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>

                                        <c:choose>
                                            <c:when test="${user.active}">
                                                <a href="${pageContext.request.contextPath}/admin/users?action=deactivate&userId=${user.userId}"
                                                   class="btn btn-sm btn-secondary" title="Deactivate"
                                                   onclick="return confirm('Deactivate this user?')">
                                                    <i class="fas fa-user-slash"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/admin/users?action=activate&userId=${user.userId}"
                                                   class="btn btn-sm btn-success" title="Activate"
                                                   onclick="return confirm('Activate this user?')">
                                                    <i class="fas fa-user-check"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>

                                        <a href="${pageContext.request.contextPath}/admin/users?action=delete&userId=${user.userId}"
                                           class="btn btn-sm btn-danger" title="Delete"
                                           onclick="return confirmDelete('Are you sure you want to delete this user?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-users-slash"></i>
                        <h3>No users found</h3>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Add User Modal -->
<div id="addUserModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-user-plus"></i> Add New User</h3>
            <span class="close" onclick="closeAddUserModal()">&times;</span>
        </div>
        <form action="${pageContext.request.contextPath}/admin/users" method="POST">
            <input type="hidden" name="action" value="add">

            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="tel" id="phone" name="phone" class="form-control" pattern="[0-9]{10}">
                </div>

                <div class="form-group">
                    <label for="role">Role *</label>
                    <select id="role" name="role" class="form-control" required>
                        <option value="CUSTOMER">Customer</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Password *</label>
                <input type="password" id="password" name="password" class="form-control" required minlength="8">
                <small class="form-text">Minimum 8 characters</small>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeAddUserModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Add User
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Edit User Modal -->
<div id="editUserModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-user-edit"></i> Edit User</h3>
            <span class="close" onclick="closeEditUserModal()">&times;</span>
        </div>
        <form action="${pageContext.request.contextPath}/admin/users" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="editUserId" name="userId">

            <div class="form-row">
                <div class="form-group">
                    <label for="editFullName">Full Name *</label>
                    <input type="text" id="editFullName" name="fullName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="editPhone">Phone</label>
                    <input type="tel" id="editPhone" name="phone" class="form-control" pattern="[0-9]{10}">
                </div>
            </div>

            <div class="form-group">
                <label for="editAddress">Address</label>
                <input type="text" id="editAddress" name="address" class="form-control">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="editCity">City</label>
                    <input type="text" id="editCity" name="city" class="form-control">
                </div>

                <div class="form-group">
                    <label for="editState">State</label>
                    <input type="text" id="editState" name="state" class="form-control">
                </div>

                <div class="form-group">
                    <label for="editZipCode">Zip Code</label>
                    <input type="text" id="editZipCode" name="zipCode" class="form-control">
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeEditUserModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Update User
                </button>
            </div>
        </form>
    </div>
</div>

<style>
    .admin-toolbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .search-box {
        position: relative;
        flex: 1;
        max-width: 400px;
    }

    .search-box i {
        position: absolute;
        left: 1rem;
        top: 50%;
        transform: translateY(-50%);
        color: var(--gray);
    }

    .search-box input {
        width: 100%;
        padding: 0.75rem 1rem 0.75rem 3rem;
        border: 2px solid var(--gray-light);
        border-radius: var(--radius-md);
        font-size: 1rem;
    }

    .filter-group {
        display: flex;
        gap: 1rem;
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .user-avatar {
        font-size: 1.5rem;
        color: var(--primary-color);
    }

    .action-buttons {
        display: flex;
        gap: 0.3rem;
        flex-wrap: wrap;
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
        margin: 5% auto;
        padding: 0;
        border-radius: var(--radius-lg);
        width: 90%;
        max-width: 600px;
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

    .modal form {
        padding: 1.5rem;
    }

    .modal-actions {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        margin-top: 1.5rem;
    }

    .form-row {
        display: flex;
        gap: 1rem;
        margin-bottom: 1rem;
    }

    .form-group {
        flex: 1;
        margin-bottom: 1rem;
    }

    .form-group label {
        display: block;
        margin-bottom: 0.5rem;
        font-weight: 600;
        color: var(--dark);
    }

    .form-control {
        width: 100%;
        padding: 0.75rem;
        border: 2px solid var(--gray-light);
        border-radius: var(--radius-md);
        font-size: 1rem;
        transition: var(--transition);
    }

    .form-control:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.1);
    }

    .form-text {
        font-size: 0.875rem;
        color: var(--gray);
        margin-top: 0.25rem;
    }
</style>

<script>
    function openAddUserModal() {
        document.getElementById('addUserModal').style.display = 'block';
    }

    function closeAddUserModal() {
        document.getElementById('addUserModal').style.display = 'none';
    }

    function editUser(userId, fullName, phone, address, city, state, zipCode) {
        // Populate the edit form with user data
        document.getElementById('editUserId').value = userId;
        document.getElementById('editFullName').value = fullName || '';
        document.getElementById('editPhone').value = phone || '';
        document.getElementById('editAddress').value = address || '';
        document.getElementById('editCity').value = city || '';
        document.getElementById('editState').value = state || '';
        document.getElementById('editZipCode').value = zipCode || '';
        
        // Show the edit modal
        document.getElementById('editUserModal').style.display = 'block';
    }

    function closeEditUserModal() {
        document.getElementById('editUserModal').style.display = 'none';
    }

    function searchUsers() {
        const input = document.getElementById('userSearch').value.toLowerCase();
        const table = document.getElementById('usersTable');
        const rows = table.getElementsByTagName('tr');

        for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(input) ? '' : 'none';
        }
    }

    function filterUsers() {
        const roleFilter = document.getElementById('roleFilter').value;
        const statusFilter = document.getElementById('statusFilter').value;
        const rows = document.querySelectorAll('#usersTable tbody tr');

        rows.forEach(row => {
            const role = row.dataset.role;
            const status = row.dataset.status;

            const roleMatch = !roleFilter || role === roleFilter;
            const statusMatch = !statusFilter || status === statusFilter;

            row.style.display = (roleMatch && statusMatch) ? '' : 'none';
        });
    }

    function viewUser(userId) {
        // You can implement a view modal or redirect to profile
        alert('View user details for ID: ' + userId);
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        const addModal = document.getElementById('addUserModal');
        const editModal = document.getElementById('editUserModal');
        
        if (event.target == addModal) {
            addModal.style.display = 'none';
        }
        if (event.target == editModal) {
            editModal.style.display = 'none';
        }
    }
</script>

<%@ include file="../common/footer.jsp" %>
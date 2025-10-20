<!-- FILE: src/main/webapp/jsp/admin/manageBookings.jsp -->

<%@ page import="com.vehiclerental.dao.BookingDAO" %>
<%@ page import="com.vehiclerental.model.Booking" %>
<%@ page import="java.util.List" %>

<%
    BookingDAO bookingDAO = new BookingDAO();
    List<Booking> allBookings = bookingDAO.getAllBookings();
    List<Booking> pendingBookings = bookingDAO.getPendingBookings();
    request.setAttribute("allBookings", allBookings);
    request.setAttribute("pendingBookings", pendingBookings);
%>

<%@ include file="../common/header.jsp" %>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-calendar-check"></i> Manage Bookings</h1>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'approved'}">Booking approved successfully!</c:when>
                    <c:when test="${param.success == 'rejected'}">Booking rejected!</c:when>
                    <c:when test="${param.success == 'updated'}">Booking updated successfully!</c:when>
                    <c:when test="${param.success == 'deleted'}">Booking deleted successfully!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'notfound'}">Booking not found!</c:when>
                    <c:when test="${param.error == 'invalid_action'}">Invalid action!</c:when>
                    <c:when test="${param.error == 'approve'}">Failed to approve booking!</c:when>
                    <c:when test="${param.error == 'reject'}">Failed to reject booking!</c:when>
                    <c:when test="${param.error == 'update_failed'}">Failed to update booking!</c:when>
                    <c:when test="${param.error == 'delete_failed'}">Failed to delete booking!</c:when>
                </c:choose>
            </div>
        </c:if>

        <!-- Booking Tabs -->
        <div class="tabs">
            <button class="tab-btn active" onclick="showTab('all')">
                <i class="fas fa-list"></i> All Bookings (${allBookings.size()})
            </button>
            <button class="tab-btn" onclick="showTab('pending')">
                <i class="fas fa-clock"></i> Pending (${pendingBookings.size()})
            </button>
        </div>

        <!-- All Bookings Tab -->
        <div id="allTab" class="tab-content active">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer</th>
                        <th>Vehicle</th>
                        <th>Dates</th>
                        <th>Days</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${allBookings}" var="booking">
                        <tr>
                            <td><strong>#${booking.bookingId}</strong></td>
                            <td>${booking.userName}</td>
                            <td>${booking.vehicleName}</td>
                            <td>
                                <small>
                                        ${booking.startDate}<br>
                                    to ${booking.endDate}
                                </small>
                            </td>
                            <td>${booking.totalDays}</td>
                            <td><strong>$${booking.totalAmount}</strong></td>
                            <td>
                                    <span class="badge badge-${
                                        booking.bookingStatus == 'Approved' ? 'success' :
                                        booking.bookingStatus == 'Pending' ? 'warning' :
                                        booking.bookingStatus == 'Rejected' ? 'danger' :
                                        'info'
                                    }">
                                            ${booking.bookingStatus}
                                    </span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-info" onclick="viewBookingDetails(${booking.bookingId})" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-sm btn-warning" onclick="editBooking(${booking.bookingId})" title="Edit Booking">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-danger" onclick="deleteBooking(${booking.bookingId})" title="Delete Booking">
                                    <i class="fas fa-trash"></i>
                                </button>

                                <c:if test="${booking.bookingStatus == 'Pending'}">
                                    <button class="btn btn-sm btn-success" onclick="openApprovalModal(${booking.bookingId}, 'approve')" title="Approve">
                                        <i class="fas fa-check"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger" onclick="openApprovalModal(${booking.bookingId}, 'reject')" title="Reject">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pending Bookings Tab -->
        <div id="pendingTab" class="tab-content">
            <div class="pending-bookings-grid">
                <c:forEach items="${pendingBookings}" var="booking">
                    <div class="pending-booking-card">
                        <div class="booking-card-header">
                            <h3>Booking #${booking.bookingId}</h3>
                            <span class="badge badge-warning">Pending Approval</span>
                        </div>

                        <div class="booking-card-body">
                            <div class="booking-detail">
                                <i class="fas fa-user"></i>
                                <div>
                                    <strong>Customer</strong>
                                    <p>${booking.userName}</p>
                                </div>
                            </div>

                            <div class="booking-detail">
                                <i class="fas fa-car"></i>
                                <div>
                                    <strong>Vehicle</strong>
                                    <p>${booking.vehicleName}</p>
                                </div>
                            </div>

                            <div class="booking-detail">
                                <i class="fas fa-calendar"></i>
                                <div>
                                    <strong>Duration</strong>
                                    <p>${booking.startDate} to ${booking.endDate}</p>
                                    <small>${booking.totalDays} days</small>
                                </div>
                            </div>

                            <div class="booking-detail">
                                <i class="fas fa-map-marker-alt"></i>
                                <div>
                                    <strong>Locations</strong>
                                    <p>Pickup: ${booking.pickupLocation}</p>
                                    <p>Drop-off: ${booking.dropoffLocation}</p>
                                </div>
                            </div>

                            <c:if test="${booking.specialRequests != null}">
                                <div class="booking-detail">
                                    <i class="fas fa-comment"></i>
                                    <div>
                                        <strong>Special Requests</strong>
                                        <p>${booking.specialRequests}</p>
                                    </div>
                                </div>
                            </c:if>

                            <div class="booking-amount">
                                <strong>Total Amount:</strong>
                                <span class="amount">$${booking.totalAmount}</span>
                            </div>
                        </div>

                        <div class="booking-card-actions">
                            <button class="btn btn-success" onclick="openApprovalModal(${booking.bookingId}, 'approve')">
                                <i class="fas fa-check"></i> Approve
                            </button>
                            <button class="btn btn-danger" onclick="openApprovalModal(${booking.bookingId}, 'reject')">
                                <i class="fas fa-times"></i> Reject
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- Approval Modal -->
<div id="approvalModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="approvalTitle"></h3>
            <span class="close" onclick="closeApprovalModal()">&times;</span>
        </div>
        <form action="${pageContext.request.contextPath}/admin/approveBooking" method="POST">
            <div class="modal-body" style="padding: 1.5rem;">
                <input type="hidden" id="bookingId" name="bookingId">
                <input type="hidden" id="action" name="action">

                <div class="form-group">
                    <label for="adminRemarks">Remarks</label>
                    <textarea id="adminRemarks" name="adminRemarks" class="form-control" rows="4"
                              placeholder="Add any remarks or notes..."></textarea>
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeApprovalModal()">Cancel</button>
                <button type="submit" class="btn btn-primary" id="submitBtn">Submit</button>
            </div>
        </form>
    </div>
</div>

<style>
    .tabs {
        display: flex;
        gap: 1rem;
        margin-bottom: 2rem;
        border-bottom: 2px solid var(--light);
    }

    .tab-btn {
        padding: 1rem 2rem;
        border: none;
        background: transparent;
        cursor: pointer;
        font-weight: 600;
        color: var(--gray);
        transition: var(--transition);
        border-bottom: 3px solid transparent;
    }

    .tab-btn.active {
        color: var(--primary-color);
        border-bottom-color: var(--primary-color);
    }

    .tab-content {
        display: none;
    }

    .tab-content.active {
        display: block;
    }

    .pending-bookings-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
        gap: 2rem;
    }

    .pending-booking-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        overflow: hidden;
    }

    .booking-card-header {
        background: var(--warning-color);
        color: var(--dark);
        padding: 1rem 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .booking-card-header h3 {
        margin: 0;
        font-size: 1.2rem;
    }

    .booking-card-body {
        padding: 1.5rem;
    }

    .booking-detail {
        display: flex;
        gap: 1rem;
        margin-bottom: 1rem;
        padding-bottom: 1rem;
        border-bottom: 1px solid var(--light);
    }

    .booking-detail:last-of-type {
        border-bottom: none;
    }

    .booking-detail i {
        font-size: 1.5rem;
        color: var(--primary-color);
        width: 30px;
    }

    .booking-detail strong {
        display: block;
        color: var(--gray);
        font-size: 0.9rem;
        margin-bottom: 0.3rem;
    }

    .booking-detail p {
        margin: 0.2rem 0;
        color: var(--dark);
    }

    .booking-amount {
        background: var(--light);
        padding: 1rem;
        border-radius: var(--radius-md);
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 1rem;
    }

    .booking-amount .amount {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--primary-color);
    }

    .booking-card-actions {
        padding: 1rem 1.5rem;
        background: var(--light);
        display: flex;
        gap: 0.5rem;
    }

    .booking-card-actions .btn {
        flex: 1;
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
        max-width: 500px;
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
    function showTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

        if (tab === 'all') {
            document.querySelector('.tab-btn:first-child').classList.add('active');
            document.getElementById('allTab').classList.add('active');
        } else {
            document.querySelector('.tab-btn:last-child').classList.add('active');
            document.getElementById('pendingTab').classList.add('active');
        }
    }

    function openApprovalModal(bookingId, action) {
        document.getElementById('bookingId').value = bookingId;
        document.getElementById('action').value = action;

        const title = action === 'approve' ? 'Approve Booking' : 'Reject Booking';
        document.getElementById('approvalTitle').innerHTML = `<i class="fas fa-${action == 'approve' ? 'check' : 'times'}-circle"></i> ${title}`;

        const submitBtn = document.getElementById('submitBtn');
        submitBtn.className = `btn btn-${action == 'approve' ? 'success' : 'danger'}`;

        document.getElementById('approvalModal').style.display = 'block';
    }

    function closeApprovalModal() {
        document.getElementById('approvalModal').style.display = 'none';
    }

    function viewBookingDetails(bookingId) {
        window.location.href = '${pageContext.request.contextPath}/viewBookings?id=' + bookingId;
    }

    function editBooking(bookingId) {
        window.location.href = '${pageContext.request.contextPath}/admin/editBooking?id=' + bookingId;
    }

    function deleteBooking(bookingId) {
        if (confirm('Are you sure you want to delete this booking?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/deleteBooking';
            
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'bookingId';
            input.value = bookingId;
            
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }

    // Close modal when clicking outside of it
    window.onclick = function(event) {
        const modal = document.getElementById('approvalModal');
        if (event.target == modal) {
            closeApprovalModal();
        }
    }

    // Close modal with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeApprovalModal();
        }
    });
</script>

<%@ include file="../common/footer.jsp" %>
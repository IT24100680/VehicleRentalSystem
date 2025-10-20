<!-- FILE: src/main/webapp/jsp/staff/viewTickets.jsp -->

<%@ include file="../common/header.jsp" %>

<div class="tickets-container">
    <div class="container">
        <div class="section-header">
            <h1><i class="fas fa-ticket-alt"></i> Support Tickets</h1>
            <a href="${pageContext.request.contextPath}/createTicket" class="btn btn-primary">
                <i class="fas fa-plus"></i> Create Ticket
            </a>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'created'}">Ticket created successfully!</c:when>
                    <c:when test="${param.success == 'updated'}">Ticket updated successfully!</c:when>
                    <c:when test="${param.success == 'deleted'}">Ticket deleted successfully!</c:when>
                    <c:when test="${param.success == 'resolved'}">Ticket status updated!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <c:choose>
                    <c:when test="${param.error == 'unauthorized'}">You are not authorized to perform this action!</c:when>
                    <c:when test="${param.error == 'notfound'}">Ticket not found!</c:when>
                    <c:when test="${param.error == 'cannot_edit'}">Cannot edit this ticket!</c:when>
                    <c:when test="${param.error == 'cannot_delete'}">Cannot delete this ticket!</c:when>
                    <c:when test="${param.error == 'delete_failed'}">Failed to delete ticket!</c:when>
                    <c:when test="${param.error == 'resolve_failed'}">Failed to resolve ticket!</c:when>
                    <c:when test="${param.error == 'empty_response'}">Please provide a response!</c:when>
                    <c:otherwise>An error occurred!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Ticket Filters -->
        <div class="ticket-filters">
            <button class="filter-btn active" onclick="filterTickets('all')">
                <i class="fas fa-list"></i> All Tickets
            </button>
            <button class="filter-btn" onclick="filterTickets('Open')">
                <i class="fas fa-folder-open"></i> Open
            </button>
            <button class="filter-btn" onclick="filterTickets('In Progress')">
                <i class="fas fa-spinner"></i> In Progress
            </button>
            <button class="filter-btn" onclick="filterTickets('Resolved')">
                <i class="fas fa-check-circle"></i> Resolved
            </button>
        </div>

        <c:choose>
            <c:when test="${tickets != null && tickets.size() > 0}">
                <div class="tickets-list">
                    <c:forEach items="${tickets}" var="ticket">
                        <div class="ticket-card" data-status="${ticket.ticketStatus}">
                            <div class="ticket-header">
                                <div class="ticket-info">
                                    <h3>${ticket.subject}</h3>
                                    <div class="ticket-meta">
                                        <span class="ticket-id">#${ticket.ticketId}</span>
                                        <span class="ticket-category">
                                            <i class="fas fa-tag"></i> ${ticket.category}
                                        </span>
                                        <span class="ticket-date">
                                            <i class="fas fa-clock"></i> ${ticket.createdAt}
                                        </span>
                                    </div>
                                </div>
                                <div class="ticket-badges">
                                    <span class="badge badge-priority badge-${
                                        ticket.priority == 'Urgent' ? 'danger' :
                                        ticket.priority == 'High' ? 'warning' :
                                        ticket.priority == 'Medium' ? 'info' :
                                        'secondary'
                                    }">
                                            ${ticket.priority}
                                    </span>
                                    <span class="badge badge-${
                                        ticket.ticketStatus == 'Resolved' ? 'success' :
                                        ticket.ticketStatus == 'In Progress' ? 'info' :
                                        ticket.ticketStatus == 'Closed' ? 'secondary' :
                                        'warning'
                                    }">
                                            ${ticket.ticketStatus}
                                    </span>
                                </div>
                            </div>

                            <div class="ticket-body">
                                <p class="ticket-description">${ticket.description}</p>

                                <c:if test="${ticket.adminResponse != null}">
                                    <div class="admin-response">
                                        <h4><i class="fas fa-user-shield"></i> Admin Response:</h4>
                                        <p>${ticket.adminResponse}</p>
                                        <c:if test="${ticket.resolvedAt != null}">
                                            <small class="resolved-time">
                                                <i class="fas fa-check"></i> Resolved on ${ticket.resolvedAt}
                                            </small>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>

                            <div class="ticket-actions">
                                <a href="${pageContext.request.contextPath}/viewTickets?id=${ticket.ticketId}"
                                   class="btn btn-sm btn-info">
                                    <i class="fas fa-eye"></i> View Details
                                </a>

                                <c:if test="${ticket.ticketStatus == 'Open' && sessionScope.userId == ticket.userId}">
                                    <a href="${pageContext.request.contextPath}/updateTicket?id=${ticket.ticketId}"
                                       class="btn btn-sm btn-warning">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>

                                    <form action="${pageContext.request.contextPath}/updateTicket" method="POST"
                                          style="display:inline;" onsubmit="return confirmDelete('Are you sure you want to delete this ticket?')">
                                        <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                        <input type="hidden" name="action" value="delete">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${sessionScope.userRole == 'ADMIN' && ticket.ticketStatus != 'Closed'}">
                                    <button class="btn btn-sm btn-success" onclick="openResolveModal(${ticket.ticketId})">
                                        <i class="fas fa-check"></i> Resolve
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-ticket-alt"></i>
                    <h3>No tickets found</h3>
                    <p>Create a ticket to get support from our team</p>
                    <a href="${pageContext.request.contextPath}/createTicket" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Create Ticket
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Resolve Ticket Modal -->
<div id="resolveModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-check-circle"></i> Resolve Ticket</h3>
            <span class="close" onclick="closeResolveModal()">&times;</span>
        </div>
        <form action="${pageContext.request.contextPath}/admin/resolveTicket" method="POST">
            <input type="hidden" id="modalTicketId" name="ticketId">

            <div class="form-group">
                <label for="status">Status</label>
                <select id="status" name="status" class="form-control" required>
                    <option value="In Progress">In Progress</option>
                    <option value="Resolved">Resolved</option>
                    <option value="Closed">Closed</option>
                </select>
            </div>

            <div class="form-group">
                <label for="adminResponse">Response *</label>
                <textarea id="adminResponse" name="adminResponse" class="form-control"
                          rows="5" required placeholder="Enter your response..."></textarea>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeResolveModal()">Cancel</button>
                <button type="submit" class="btn btn-success">Submit Response</button>
            </div>
        </form>
    </div>
</div>

<style>
    .tickets-container {
        padding: 3rem 0;
    }

    .ticket-filters {
        display: flex;
        gap: 1rem;
        margin: 2rem 0;
        flex-wrap: wrap;
    }

    .filter-btn {
        padding: 0.75rem 1.5rem;
        border: 2px solid var(--gray-light);
        background: var(--white);
        border-radius: var(--radius-md);
        cursor: pointer;
        transition: var(--transition);
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .filter-btn:hover,
    .filter-btn.active {
        background: var(--primary-color);
        color: var(--white);
        border-color: var(--primary-color);
    }

    .tickets-list {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }

    .ticket-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        padding: 1.5rem;
        transition: var(--transition);
    }

    .ticket-card:hover {
        box-shadow: var(--shadow-lg);
    }

    .ticket-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 1rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid var(--light);
    }

    .ticket-info h3 {
        margin-bottom: 0.5rem;
        color: var(--dark);
    }

    .ticket-meta {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
        color: var(--gray);
        font-size: 0.9rem;
    }

    .ticket-meta span {
        display: flex;
        align-items: center;
        gap: 0.3rem;
    }

    .ticket-id {
        font-weight: 600;
        color: var(--primary-color);
    }

    .ticket-badges {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .badge-priority {
        font-weight: 600;
    }

    .ticket-description {
        color: var(--dark);
        line-height: 1.6;
        margin-bottom: 1rem;
    }

    .admin-response {
        background: #e8f5e9;
        padding: 1rem;
        border-radius: var(--radius-md);
        margin-top: 1rem;
        border-left: 4px solid var(--success-color);
    }

    .admin-response h4 {
        color: var(--success-color);
        margin-bottom: 0.5rem;
        font-size: 1rem;
    }

    .admin-response p {
        color: var(--dark);
        margin-bottom: 0.5rem;
    }

    .resolved-time {
        color: var(--gray);
        font-size: 0.85rem;
    }

    .ticket-actions {
        display: flex;
        gap: 0.5rem;
        margin-top: 1rem;
        padding-top: 1rem;
        border-top: 1px solid var(--light);
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
</style>

<script>
    function filterTickets(status) {
        const cards = document.querySelectorAll('.ticket-card');
        const buttons = document.querySelectorAll('.filter-btn');

        buttons.forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');

        cards.forEach(card => {
            if (status === 'all' || card.dataset.status === status) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function openResolveModal(ticketId) {
        document.getElementById('modalTicketId').value = ticketId;
        document.getElementById('resolveModal').style.display = 'block';
    }

    function closeResolveModal() {
        document.getElementById('resolveModal').style.display = 'none';
    }

    function confirmDelete(message) {
        return confirm(message);
    }

    window.onclick = function(event) {
        const modal = document.getElementById('resolveModal');
        if (event.target == modal) {
            modal.style.display = 'none';
        }
    }
</script>

<%@ include file="../common/footer.jsp" %>
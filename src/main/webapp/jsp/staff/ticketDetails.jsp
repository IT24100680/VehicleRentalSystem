<!-- FILE: src/main/webapp/jsp/staff/ticketDetails.jsp -->

<%@ include file="../common/header.jsp" %>

<div class="ticket-details-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/viewTickets" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Tickets
        </a>

        <div class="ticket-details-box">
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2><i class="fas fa-ticket-alt"></i> Ticket #${ticket.ticketId}</h2>
                        <p class="ticket-subject">${ticket.subject}</p>
                    </div>
                    <div class="header-badges">
                        <span class="badge badge-${
                            ticket.priority == 'Urgent' ? 'danger' :
                            ticket.priority == 'High' ? 'warning' :
                            'info'
                        }">
                            ${ticket.priority} Priority
                        </span>
                        <span class="badge badge-${
                            ticket.ticketStatus == 'Resolved' ? 'success' :
                            ticket.ticketStatus == 'In Progress' ? 'info' :
                            'warning'
                        }">
                            ${ticket.ticketStatus}
                        </span>
                    </div>
                </div>

                <div class="card-body">
                    <div class="ticket-timeline">
                        <!-- Original Ticket -->
                        <div class="timeline-item">
                            <div class="timeline-icon timeline-icon-primary">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-header">
                                    <h4>${ticket.userName}</h4>
                                    <span class="timeline-date">${ticket.createdAt}</span>
                                </div>
                                <div class="timeline-body">
                                    <div class="ticket-meta-info">
                                        <span><i class="fas fa-tag"></i> ${ticket.category}</span>
                                        <span><i class="fas fa-envelope"></i> ${ticket.userEmail}</span>
                                    </div>
                                    <div class="ticket-description">
                                        <h5>Description:</h5>
                                        <p>${ticket.description}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Admin Response -->
                        <c:if test="${ticket.adminResponse != null}">
                            <div class="timeline-item">
                                <div class="timeline-icon timeline-icon-success">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                                <div class="timeline-content">
                                    <div class="timeline-header">
                                        <h4>Admin Response</h4>
                                        <span class="timeline-date">${ticket.updatedAt}</span>
                                    </div>
                                    <div class="timeline-body">
                                        <div class="admin-response-box">
                                            <p>${ticket.adminResponse}</p>
                                        </div>
                                        <c:if test="${ticket.resolvedAt != null}">
                                            <div class="resolved-info">
                                                <i class="fas fa-check-circle"></i>
                                                Ticket resolved on ${ticket.resolvedAt}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <div class="ticket-actions-section">
                        <c:if test="${ticket.ticketStatus == 'Open' && sessionScope.userId == ticket.userId}">
                            <a href="${pageContext.request.contextPath}/updateTicket?id=${ticket.ticketId}"
                               class="btn btn-warning">
                                <i class="fas fa-edit"></i> Edit Ticket
                            </a>
                        </c:if>

                        <c:if test="${sessionScope.userRole == 'ADMIN' && ticket.ticketStatus != 'Closed'}">
                            <button class="btn btn-success" onclick="document.getElementById('responseForm').style.display='block'">
                                <i class="fas fa-reply"></i> Add Response
                            </button>
                        </c:if>
                    </div>

                    <!-- Admin Response Form -->
                    <c:if test="${sessionScope.userRole == 'ADMIN'}">
                        <div id="responseForm" class="response-form" style="display: none;">
                            <h3><i class="fas fa-pen"></i> Add Response</h3>
                            <form action="${pageContext.request.contextPath}/admin/resolveTicket" method="POST">
                                <input type="hidden" name="ticketId" value="${ticket.ticketId}">

                                <div class="form-group">
                                    <label for="status">Update Status</label>
                                    <select id="status" name="status" class="form-control" required>
                                        <option value="In Progress">In Progress</option>
                                        <option value="Resolved">Resolved</option>
                                        <option value="Closed">Closed</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="adminResponse">Your Response *</label>
                                    <textarea id="adminResponse" name="adminResponse" class="form-control"
                                              rows="6" required placeholder="Enter your response to the customer..."></textarea>
                                </div>

                                <div class="form-actions">
                                    <button type="button" class="btn btn-secondary"
                                            onclick="document.getElementById('responseForm').style.display='none'">
                                        Cancel
                                    </button>
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-paper-plane"></i> Send Response
                                    </button>
                                </div>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .ticket-details-container {
        padding: 3rem 0;
    }

    .ticket-details-box {
        max-width: 900px;
        margin: 2rem auto;
    }

    .ticket-subject {
        font-size: 1.1rem;
        color: var(--gray);
        margin-top: 0.5rem;
    }

    .header-badges {
        display: flex;
        gap: 0.5rem;
    }

    .ticket-timeline {
        margin: 2rem 0;
    }

    .timeline-item {
        display: flex;
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .timeline-icon {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        flex-shrink: 0;
    }

    .timeline-icon-primary {
        background: var(--primary-color);
        color: var(--white);
    }

    .timeline-icon-success {
        background: var(--success-color);
        color: var(--white);
    }

    .timeline-content {
        flex: 1;
        background: var(--light);
        padding: 1.5rem;
        border-radius: var(--radius-lg);
    }

    .timeline-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid var(--gray-light);
    }

    .timeline-header h4 {
        margin: 0;
        color: var(--dark);
    }

    .timeline-date {
        color: var(--gray);
        font-size: 0.9rem;
    }

    .ticket-meta-info {
        display: flex;
        gap: 2rem;
        margin-bottom: 1rem;
        color: var(--gray);
    }

    .ticket-meta-info span {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .ticket-description h5 {
        color: var(--dark);
        margin-bottom: 0.5rem;
    }

    .ticket-description p {
        color: var(--dark);
        line-height: 1.6;
    }

    .admin-response-box {
        background: var(--white);
        padding: 1rem;
        border-radius: var(--radius-md);
        border-left: 4px solid var(--success-color);
    }

    .resolved-info {
        margin-top: 1rem;
        color: var(--success-color);
        font-weight: 600;
    }

    .ticket-actions-section {
        display: flex;
        gap: 1rem;
        margin: 2rem 0;
        padding: 1.5rem;
        background: var(--light);
        border-radius: var(--radius-md);
    }

    .response-form {
        background: var(--light);
        padding: 2rem;
        border-radius: var(--radius-lg);
        margin-top: 2rem;
    }

    .response-form h3 {
        margin-bottom: 1.5rem;
        color: var(--dark);
    }
</style>

<%@ include file="../common/footer.jsp" %>
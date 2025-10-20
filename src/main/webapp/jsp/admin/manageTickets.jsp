<!-- FILE: src/main/webapp/jsp/admin/manageTickets.jsp -->

<%@ page import="com.vehiclerental.dao.TicketDAO" %>
<%@ page import="com.vehiclerental.model.Ticket" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> allTickets = ticketDAO.getAllTickets();
    List<Ticket> openTickets = ticketDAO.getOpenTickets();
    int totalTickets = ticketDAO.getTotalTicketCount();
    int openCount = ticketDAO.getOpenTicketCount();

    request.setAttribute("allTickets", allTickets);
    request.setAttribute("openTickets", openTickets);
    request.setAttribute("totalTickets", totalTickets);
    request.setAttribute("openCount", openCount);
%>

<%@ include file="../common/header.jsp" %>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-ticket-alt"></i> Manage Support Tickets</h1>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                Ticket updated successfully!
            </div>
        </c:if>

        <!-- Statistics -->
        <div class="stats-grid" style="margin-bottom: 2rem;">
            <div class="stat-card stat-primary">
                <div class="stat-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <div class="stat-details">
                    <p>Total Tickets</p>
                    <h2>${totalTickets}</h2>
                </div>
            </div>

            <div class="stat-card stat-warning">
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-details">
                    <p>Open Tickets</p>
                    <h2>${openCount}</h2>
                </div>
            </div>

            <div class="stat-card stat-danger">
                <div class="stat-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="stat-details">
                    <p>Urgent Priority</p>
                    <h2>
                        <c:set var="urgent" value="0"/>
                        <c:forEach items="${allTickets}" var="t">
                            <c:if test="${t.priority == 'Urgent' && t.ticketStatus != 'Resolved'}">
                                <c:set var="urgent" value="${urgent + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${urgent}
                    </h2>
                </div>
            </div>

            <div class="stat-card stat-success">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-details">
                    <p>Resolved</p>
                    <h2>
                        <c:set var="resolved" value="0"/>
                        <c:forEach items="${allTickets}" var="t">
                            <c:if test="${t.ticketStatus == 'Resolved'}">
                                <c:set var="resolved" value="${resolved + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${resolved}
                    </h2>
                </div>
            </div>
        </div>

        <!-- Ticket Tabs -->
        <div class="tabs">
            <button class="tab-btn active" onclick="showTicketTab('all')">
                <i class="fas fa-list"></i> All Tickets (${allTickets.size()})
            </button>
            <button class="tab-btn" onclick="showTicketTab('open')">
                <i class="fas fa-folder-open"></i> Open (${openTickets.size()})
            </button>
        </div>

        <!-- All Tickets Tab -->
        <div id="allTicketsTab" class="tab-content active">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Category</th>
                        <th>Subject</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${allTickets}" var="ticket">
                        <tr>
                            <td><strong>#${ticket.ticketId}</strong></td>
                            <td>
                                <div>
                                    <strong>${ticket.userName}</strong><br>
                                    <small>${ticket.userEmail}</small>
                                </div>
                            </td>
                            <td>${ticket.category}</td>
                            <td>${ticket.subject}</td>
                            <td>
                                    <span class="badge badge-${
                                        ticket.priority == 'Urgent' ? 'danger' :
                                        ticket.priority == 'High' ? 'warning' :
                                        ticket.priority == 'Medium' ? 'info' :
                                        'secondary'
                                    }">
                                            ${ticket.priority}
                                    </span>
                            </td>
                            <td>
                                    <span class="badge badge-${
                                        ticket.ticketStatus == 'Resolved' ? 'success' :
                                        ticket.ticketStatus == 'In Progress' ? 'info' :
                                        ticket.ticketStatus == 'Closed' ? 'secondary' :
                                        'warning'
                                    }">
                                            ${ticket.ticketStatus}
                                    </span>
                            </td>
                            <td><fmt:formatDate value="${ticket.createdAt}" pattern="MMM dd, yyyy"/></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/viewTickets?id=${ticket.ticketId}"
                                   class="btn btn-sm btn-info">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <c:if test="${ticket.ticketStatus != 'Closed'}">
                                    <button class="btn btn-sm btn-success"
                                            onclick="openResolveTicketModal(${ticket.ticketId})">
                                        <i class="fas fa-check"></i>
                                    </button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Open Tickets Tab -->
        <div id="openTicketsTab" class="tab-content">
            <div class="tickets-admin-grid">
                <c:forEach items="${openTickets}" var="ticket">
                    <div class="ticket-admin-card priority-${ticket.priority.toLowerCase()}">
                        <div class="ticket-admin-header">
                            <div>
                                <h3>${ticket.subject}</h3>
                                <p class="ticket-meta">
                                    <i class="fas fa-user"></i> ${ticket.userName} |
                                    <i class="fas fa-envelope"></i> ${ticket.userEmail}
                                </p>
                            </div>
                            <div class="ticket-badges">
                                <span class="badge badge-${
                                    ticket.priority == 'Urgent' ? 'danger' :
                                    ticket.priority == 'High' ? 'warning' :
                                    'info'
                                }">
                                        ${ticket.priority}
                                </span>
                                <span class="badge badge-warning">${ticket.ticketStatus}</span>
                            </div>
                        </div>

                        <div class="ticket-admin-body">
                            <p class="ticket-category">
                                <i class="fas fa-tag"></i> ${ticket.category}
                            </p>
                            <p class="ticket-description">${ticket.description}</p>
                            <p class="ticket-date">
                                <i class="fas fa-clock"></i>
                                Created: <fmt:formatDate value="${ticket.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                            </p>
                        </div>

                        <div class="ticket-admin-footer">
                            <button class="btn btn-success btn-block"
                                    onclick="openResolveTicketModal(${ticket.ticketId})">
                                <i class="fas fa-reply"></i> Respond & Resolve
                            </button>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${openTickets.size() == 0}">
                    <div class="empty-state-small">
                        <i class="fas fa-check-circle"></i>
                        <p>No open tickets</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Resolve Ticket Modal -->
<div id="resolveTicketModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-check-circle"></i> Resolve Ticket</h3>
            <span class="close" onclick="closeResolveTicketModal()">&times;</span>
        </div>
        <form action="${pageContext.request.contextPath}/admin/resolveTicket" method="POST">
            <input type="hidden" id="ticketIdModal" name="ticketId">

            <div class="form-group">
                <label for="status">Update Status *</label>
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

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeResolveTicketModal()">Cancel</button>
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-paper-plane"></i> Send Response
                </button>
            </div>
        </form>
    </div>
</div>

<style>
    .tickets-admin-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
        gap: 2rem;
    }

    .ticket-admin-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        overflow: hidden;
        border-left: 4px solid var(--primary-color);
    }

    .ticket-admin-card.priority-urgent {
        border-left-color: var(--danger-color);
    }

    .ticket-admin-card.priority-high {
        border-left-color: var(--warning-color);
    }

    .ticket-admin-header {
        padding: 1.5rem;
        border-bottom: 2px solid var(--light);
    }

    .ticket-admin-header h3 {
        margin: 0 0 0.5rem 0;
        color: var(--dark);
    }

    .ticket-meta {
        color: var(--gray);
        font-size: 0.9rem;
        margin: 0;
    }

    .ticket-badges {
        display: flex;
        gap: 0.5rem;
        margin-top: 0.5rem;
    }

    .ticket-admin-body {
        padding: 1.5rem;
    }

    .ticket-category {
        color: var(--primary-color);
        font-weight: 600;
        margin-bottom: 1rem;
    }

    .ticket-description {
        color: var(--dark);
        line-height: 1.6;
        margin-bottom: 1rem;
    }

    .ticket-date {
        color: var(--gray);
        font-size: 0.9rem;
    }

    .ticket-admin-footer {
        padding: 1rem 1.5rem;
        background: var(--light);
    }
</style>

<script>
    function showTicketTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

        if (tab === 'all') {
            document.querySelector('.tab-btn:nth-child(1)').classList.add('active');
            document.getElementById('allTicketsTab').classList.add('active');
        } else {
            document.querySelector('.tab-btn:nth-child(2)').classList.add('active');
            document.getElementById('openTicketsTab').classList.add('active');
        }
    }

    function openResolveTicketModal(ticketId) {
        document.getElementById('ticketIdModal').value = ticketId;
        document.getElementById('resolveTicketModal').style.display = 'block';
    }

    function closeResolveTicketModal() {
        document.getElementById('resolveTicketModal').style.display = 'none';
    }
</script>

<%@ include file="../common/footer.jsp" %>
<!-- FILE: src/main/webapp/jsp/staff/editTicket.jsp -->

<%@ include file="../common/header.jsp" %>

<div class="ticket-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/viewTickets" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Tickets
        </a>

        <div class="ticket-box">
            <div class="card">
                <div class="card-header">
                    <h2><i class="fas fa-edit"></i> Edit Ticket #${ticket.ticketId}</h2>
                </div>

                <div class="card-body">
                    <c:if test="${errorMessage != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/updateTicket" method="POST" class="ticket-form">
                        <input type="hidden" name="ticketId" value="${ticket.ticketId}">

                        <div class="form-row">
                            <div class="form-group">
                                <label for="category">
                                    <i class="fas fa-list"></i> Category *
                                </label>
                                <select id="category" name="category" class="form-control" required>
                                    <option value="Booking Issue" ${ticket.category == 'Booking Issue' ? 'selected' : ''}>Booking Issue</option>
                                    <option value="Payment Issue" ${ticket.category == 'Payment Issue' ? 'selected' : ''}>Payment Issue</option>
                                    <option value="Vehicle Issue" ${ticket.category == 'Vehicle Issue' ? 'selected' : ''}>Vehicle Issue</option>
                                    <option value="Technical Support" ${ticket.category == 'Technical Support' ? 'selected' : ''}>Technical Support</option>
                                    <option value="General Inquiry" ${ticket.category == 'General Inquiry' ? 'selected' : ''}>General Inquiry</option>
                                    <option value="Complaint" ${ticket.category == 'Complaint' ? 'selected' : ''}>Complaint</option>
                                    <option value="Other" ${ticket.category == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="priority">
                                    <i class="fas fa-exclamation-circle"></i> Priority
                                </label>
                                <select id="priority" name="priority" class="form-control">
                                    <option value="Low" ${ticket.priority == 'Low' ? 'selected' : ''}>Low</option>
                                    <option value="Medium" ${ticket.priority == 'Medium' ? 'selected' : ''}>Medium</option>
                                    <option value="High" ${ticket.priority == 'High' ? 'selected' : ''}>High</option>
                                    <option value="Urgent" ${ticket.priority == 'Urgent' ? 'selected' : ''}>Urgent</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="subject">
                                <i class="fas fa-heading"></i> Subject *
                            </label>
                            <input type="text" id="subject" name="subject" class="form-control"
                                   required value="${ticket.subject}">
                        </div>

                        <div class="form-group">
                            <label for="description">
                                <i class="fas fa-align-left"></i> Description *
                            </label>
                            <textarea id="description" name="description" class="form-control"
                                      rows="8" required>${ticket.description}</textarea>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/viewTickets" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Ticket
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
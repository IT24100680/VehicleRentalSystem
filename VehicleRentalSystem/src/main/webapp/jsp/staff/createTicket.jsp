<%@ include file="../common/header.jsp" %>

<div class="ticket-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/viewTickets" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Tickets
        </a>

        <div class="ticket-box">
            <div class="card">
                <div class="card-header">
                    <h2><i class="fas fa-ticket-alt"></i> Create Support Ticket</h2>
                    <p>Need help? Our support team is here for you!</p>
                </div>

                <div class="card-body">
                    <c:if test="${errorMessage != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/createTicket" method="POST" class="ticket-form">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="category">
                                    <i class="fas fa-list"></i> Category *
                                </label>
                                <select id="category" name="category" class="form-control" required>
                                    <option value="">Select Category</option>
                                    <option value="Booking Issue">Booking Issue</option>
                                    <option value="Payment Issue">Payment Issue</option>
                                    <option value="Vehicle Issue">Vehicle Issue</option>
                                    <option value="Technical Support">Technical Support</option>
                                    <option value="General Inquiry">General Inquiry</option>
                                    <option value="Complaint">Complaint</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="priority">
                                    <i class="fas fa-exclamation-circle"></i> Priority
                                </label>
                                <select id="priority" name="priority" class="form-control">
                                    <option value="Low">Low</option>
                                    <option value="Medium" selected>Medium</option>
                                    <option value="High">High</option>
                                    <option value="Urgent">Urgent</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="subject">
                                <i class="fas fa-heading"></i> Subject *
                            </label>
                            <input type="text" id="subject" name="subject" class="form-control"
                                   required placeholder="Brief summary of your issue">
                        </div>

                        <div class="form-group">
                            <label for="description">
                                <i class="fas fa-align-left"></i> Description *
                            </label>
                            <textarea id="description" name="description" class="form-control"
                                      rows="8" required placeholder="Please provide detailed information about your issue..."></textarea>
                            <small class="form-text">Be as specific as possible to help us resolve your issue quickly</small>
                        </div>

                        <div class="help-info">
                            <h4><i class="fas fa-info-circle"></i> Response Time</h4>
                            <ul>
                                <li><strong>Urgent:</strong> Within 2 hours</li>
                                <li><strong>High:</strong> Within 6 hours</li>
                                <li><strong>Medium:</strong> Within 24 hours</li>
                                <li><strong>Low:</strong> Within 48 hours</li>
                            </ul>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/viewTickets" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> Submit Ticket
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .ticket-container {
        padding: 3rem 0;
    }

    .ticket-box {
        max-width: 900px;
        margin: 2rem auto;
    }

    .help-info {
        background: var(--light);
        padding: 1.5rem;
        border-radius: var(--radius-md);
        margin: 1.5rem 0;
        border-left: 4px solid var(--info-color);
    }

    .help-info h4 {
        color: var(--info-color);
        margin-bottom: 1rem;
    }

    .help-info ul {
        margin-left: 1.5rem;
    }

    .help-info li {
        margin-bottom: 0.5rem;
    }
</style>

<%@ include file="../common/footer.jsp" %>
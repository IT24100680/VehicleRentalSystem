<%@ include file="../common/header.jsp" %>

<div class="refund-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/viewPayments" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Payments
        </a>

        <div class="refund-box">
            <div class="card">
                <div class="card-header">
                    <h2><i class="fas fa-undo"></i> Request Refund</h2>
                </div>

                <div class="card-body">
                    <div class="payment-details">
                        <h3>Payment Details</h3>
                        <div class="detail-item">
                            <strong>Transaction ID:</strong>
                            <span>${payment.transactionId}</span>
                        </div>
                        <div class="detail-item">
                            <strong>Amount:</strong>
                            <span class="amount">$${payment.amount}</span>
                        </div>
                        <div class="detail-item">
                            <strong>Payment Date:</strong>
                            <span>${payment.paymentDate}</span>
                        </div>
                        <div class="detail-item">
                            <strong>Vehicle:</strong>
                            <span>${payment.vehicleName}</span>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/refundRequest" method="POST"
                          onsubmit="return confirm('Are you sure you want to request a refund?')">

                        <input type="hidden" name="paymentId" value="${payment.paymentId}">

                        <div class="form-group">
                            <label for="refundReason">
                                <i class="fas fa-comment"></i> Reason for Refund *
                            </label>
                            <textarea id="refundReason" name="refundReason" class="form-control"
                                      rows="6" required placeholder="Please explain why you're requesting a refund..."></textarea>
                            <small class="form-text">Provide a detailed explanation for your refund request</small>
                        </div>

                        <div class="refund-policy">
                            <h4><i class="fas fa-info-circle"></i> Refund Policy</h4>
                            <ul>
                                <li>Refunds are processed within 7-10 business days</li>
                                <li>Cancellations made 24 hours before pickup: 100% refund</li>
                                <li>Cancellations made 12-24 hours before: 50% refund</li>
                                <li>Cancellations less than 12 hours: No refund</li>
                                <li>Admin approval is required for all refunds</li>
                            </ul>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/viewPayments" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-warning">
                                <i class="fas fa-paper-plane"></i> Submit Refund Request
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .refund-container {
        padding: 3rem 0;
    }

    .refund-box {
        max-width: 800px;
        margin: 2rem auto;
    }

    .payment-details {
        background: var(--light);
        padding: 1.5rem;
        border-radius: var(--radius-md);
        margin-bottom: 2rem;
    }

    .payment-details h3 {
        margin-bottom: 1rem;
    }

    .detail-item {
        display: flex;
        justify-content: space-between;
        padding: 0.5rem 0;
        border-bottom: 1px solid var(--gray-light);
    }

    .detail-item .amount {
        color: var(--primary-color);
        font-size: 1.3rem;
        font-weight: 700;
    }

    .refund-policy {
        background: #fff3cd;
        padding: 1.5rem;
        border-radius: var(--radius-md);
        margin: 1.5rem 0;
        border-left: 4px solid var(--warning-color);
    }

    .refund-policy h4 {
        color: var(--warning-color);
        margin-bottom: 1rem;
    }

    .refund-policy ul {
        margin-left: 1.5rem;
        color: var(--dark);
    }

    .refund-policy li {
        margin-bottom: 0.5rem;
    }
</style>

<%@ include file="../common/footer.jsp" %>
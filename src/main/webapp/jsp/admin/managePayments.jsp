<%@ page import="com.vehiclerental.dao.PaymentDAO" %>
<%@ page import="com.vehiclerental.model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    PaymentDAO paymentDAO = new PaymentDAO();
    List<Payment> allPayments = paymentDAO.getAllPayments();
    List<Payment> pendingPayments = paymentDAO.getPendingPayments();
    List<Payment> refundRequests = paymentDAO.getRefundRequests();
    double totalRevenue = paymentDAO.getTotalRevenue();

    request.setAttribute("allPayments", allPayments);
    request.setAttribute("pendingPayments", pendingPayments);
    request.setAttribute("refundRequests", refundRequests);
    request.setAttribute("totalRevenue", totalRevenue);
%>

<%@ include file="../common/header.jsp" %>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-credit-card"></i> Manage Payments</h1>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'approve_payment'}">Payment approved successfully!</c:when>
                    <c:when test="${param.success == 'reject_payment'}">Payment rejected!</c:when>
                    <c:when test="${param.success == 'approve_refund'}">Refund approved!</c:when>
                    <c:when test="${param.success == 'reject_refund'}">Refund rejected!</c:when>
                </c:choose>
            </div>
        </c:if>

        <!-- Statistics Cards -->
        <div class="stats-grid" style="margin-bottom: 2rem;">
            <div class="stat-card stat-success">
                <div class="stat-icon">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="stat-details">
                    <p>Total Revenue</p>
                    <h2>$<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></h2>
                </div>
            </div>

            <div class="stat-card stat-warning">
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-details">
                    <p>Pending Payments</p>
                    <h2>${pendingPayments.size()}</h2>
                </div>
            </div>

            <div class="stat-card stat-danger">
                <div class="stat-icon">
                    <i class="fas fa-undo"></i>
                </div>
                <div class="stat-details">
                    <p>Refund Requests</p>
                    <h2>${refundRequests.size()}</h2>
                </div>
            </div>

            <div class="stat-card stat-info">
                <div class="stat-icon">
                    <i class="fas fa-list"></i>
                </div>
                <div class="stat-details">
                    <p>Total Transactions</p>
                    <h2>${allPayments.size()}</h2>
                </div>
            </div>
        </div>

        <!-- Payment Tabs -->
        <div class="tabs">
            <button class="tab-btn active" onclick="showPaymentTab('all')">
                <i class="fas fa-list"></i> All Payments (${allPayments.size()})
            </button>
            <button class="tab-btn" onclick="showPaymentTab('pending')">
                <i class="fas fa-clock"></i> Pending (${pendingPayments.size()})
            </button>
            <button class="tab-btn" onclick="showPaymentTab('refunds')">
                <i class="fas fa-undo"></i> Refund Requests (${refundRequests.size()})
            </button>
        </div>

        <!-- All Payments Tab -->
        <div id="allPaymentsTab" class="tab-content active">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Transaction ID</th>
                        <th>Customer</th>
                        <th>Vehicle</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${allPayments}" var="payment">
                        <tr>
                            <td><strong>${payment.transactionId}</strong></td>
                            <td>${payment.userName}</td>
                            <td>${payment.vehicleName}</td>
                            <td><strong>$${payment.amount}</strong></td>
                            <td>
                                <i class="fas fa-${
                                        payment.paymentMethod == 'Credit Card' ? 'credit-card' :
                                        payment.paymentMethod == 'Debit Card' ? 'credit-card' :
                                        payment.paymentMethod == 'PayPal' ? 'paypal' :
                                        'university'
                                    }"></i>
                                    ${payment.paymentMethod}
                            </td>
                            <td><fmt:formatDate value="${payment.paymentDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>
                                    <span class="badge badge-${
                                        payment.paymentStatus == 'Approved' ? 'success' :
                                        payment.paymentStatus == 'Pending' ? 'warning' :
                                        payment.paymentStatus == 'Rejected' ? 'danger' :
                                        'info'
                                    }">
                                            ${payment.paymentStatus}
                                    </span>
                                <c:if test="${payment.refundRequested}">
                                    <br><span class="badge badge-info">Refund: ${payment.refundStatus}</span>
                                </c:if>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-info" onclick="viewPaymentDetails(${payment.paymentId})">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pending Payments Tab -->
        <div id="pendingPaymentsTab" class="tab-content">
            <div class="payment-cards-grid">
                <c:forEach items="${pendingPayments}" var="payment">
                    <div class="payment-card">
                        <div class="payment-card-header">
                            <h3><i class="fas fa-receipt"></i> ${payment.transactionId}</h3>
                            <span class="badge badge-warning">Pending</span>
                        </div>
                        <div class="payment-card-body">
                            <div class="payment-detail">
                                <strong>Customer:</strong>
                                <span>${payment.userName}</span>
                            </div>
                            <div class="payment-detail">
                                <strong>Vehicle:</strong>
                                <span>${payment.vehicleName}</span>
                            </div>
                            <div class="payment-detail">
                                <strong>Amount:</strong>
                                <span class="amount-lg">$${payment.amount}</span>
                            </div>
                            <div class="payment-detail">
                                <strong>Method:</strong>
                                <span>${payment.paymentMethod}</span>
                            </div>
                            <div class="payment-detail">
                                <strong>Card:</strong>
                                <span>${payment.getMaskedCardNumber()}</span>
                            </div>
                            <div class="payment-detail">
                                <strong>Date:</strong>
                                <span><fmt:formatDate value="${payment.paymentDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                            </div>
                        </div>
                        <div class="payment-card-actions">
                            <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                <input type="hidden" name="action" value="approve_payment">
                                <button type="submit" class="btn btn-success" onclick="return confirm('Approve this payment?')">
                                    <i class="fas fa-check"></i> Approve
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                <input type="hidden" name="action" value="reject_payment">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Reject this payment?')">
                                    <i class="fas fa-times"></i> Reject
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${pendingPayments.size() == 0}">
                    <div class="empty-state-small">
                        <i class="fas fa-check-circle"></i>
                        <p>No pending payments</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Refund Requests Tab -->
        <div id="refundsTab" class="tab-content">
            <div class="payment-cards-grid">
                <c:forEach items="${refundRequests}" var="payment">
                    <div class="payment-card refund-card">
                        <div class="payment-card-header">
                            <h3><i class="fas fa-undo"></i> ${payment.transactionId}</h3>
                            <span class="badge badge-warning">Refund Requested</span>
                        </div>
                        <div class="payment-card-body">
                            <div class="payment-detail">
                                <strong>Customer:</strong>
                                <span>${payment.userName}</span>
                            </div>
                            <div class="payment-detail">
                                <strong>Original Amount:</strong>
                                <span class="amount-lg">$${payment.amount}</span>
                            </div>
                            <div class="payment-detail">
                                <strong>Payment Date:</strong>
                                <span><fmt:formatDate value="${payment.paymentDate}" pattern="yyyy-MM-dd"/></span>
                            </div>
                            <div class="refund-reason">
                                <strong>Refund Reason:</strong>
                                <p>${payment.refundReason}</p>
                            </div>
                        </div>
                        <div class="payment-card-actions">
                            <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                <input type="hidden" name="action" value="approve_refund">
                                <input type="hidden" name="adminRemarks" value="Refund approved">
                                <button type="submit" class="btn btn-success" onclick="return confirm('Approve refund request?')">
                                    <i class="fas fa-check"></i> Approve Refund
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                <input type="hidden" name="action" value="reject_refund">
                                <input type="hidden" name="adminRemarks" value="Refund rejected">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Reject refund request?')">
                                    <i class="fas fa-times"></i> Reject
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${refundRequests.size() == 0}">
                    <div class="empty-state-small">
                        <i class="fas fa-check-circle"></i>
                        <p>No refund requests</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<style>
    .payment-cards-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 2rem;
    }

    .payment-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        overflow: hidden;
    }

    .refund-card {
        border: 2px solid var(--warning-color);
    }

    .payment-card-header {
        background: var(--light);
        padding: 1rem 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid var(--gray-light);
    }

    .payment-card-header h3 {
        margin: 0;
        font-size: 1rem;
    }

    .payment-card-body {
        padding: 1.5rem;
    }

    .payment-detail {
        display: flex;
        justify-content: space-between;
        padding: 0.5rem 0;
        border-bottom: 1px solid var(--light);
    }

    .payment-detail strong {
        color: var(--gray);
    }

    .amount-lg {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--primary-color);
    }

    .refund-reason {
        background: var(--light);
        padding: 1rem;
        border-radius: var(--radius-md);
        margin-top: 1rem;
    }

    .refund-reason strong {
        display: block;
        margin-bottom: 0.5rem;
        color: var(--dark);
    }

    .refund-reason p {
        margin: 0;
        color: var(--gray);
    }

    .payment-card-actions {
        padding: 1rem 1.5rem;
        background: var(--light);
        display: flex;
        gap: 0.5rem;
    }

    .payment-card-actions .btn {
        flex: 1;
    }
</style>

<script>
    function showPaymentTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

        if (tab === 'all') {
            document.querySelector('.tab-btn:nth-child(1)').classList.add('active');
            document.getElementById('allPaymentsTab').classList.add('active');
        } else if (tab === 'pending') {
            document.querySelector('.tab-btn:nth-child(2)').classList.add('active');
            document.getElementById('pendingPaymentsTab').classList.add('active');
        } else if (tab === 'refunds') {
            document.querySelector('.tab-btn:nth-child(3)').classList.add('active');
            document.getElementById('refundsTab').classList.add('active');
        }
    }

    function viewPaymentDetails(paymentId) {
        alert('View payment details: ' + paymentId);
    }
</script>

<%@ include file="../common/footer.jsp" %>
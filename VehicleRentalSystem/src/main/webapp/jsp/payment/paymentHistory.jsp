<%@ include file="../common/header.jsp" %>

<div class="dashboard-section">
    <div class="container">
        <div class="section-header">
            <h1><i class="fas fa-receipt"></i> Payment History</h1>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'created'}">Payment submitted successfully! Awaiting admin approval.</c:when>
                    <c:when test="${param.success == 'updated'}">Payment details updated successfully!</c:when>
                    <c:when test="${param.success == 'refund_requested'}">Refund request submitted successfully!</c:when>
                    <c:when test="${param.success == 'approve_payment'}">Payment approved!</c:when>
                    <c:when test="${param.success == 'approve_refund'}">Refund approved!</c:when>
                </c:choose>
            </div>
        </c:if>

        <div class="table-responsive">
            <c:choose>
                <c:when test="${payments != null && payments.size() > 0}">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>Transaction ID</th>
                            <th>Booking ID</th>
                            <th>Vehicle</th>
                            <th>Amount</th>
                            <th>Method</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${payments}" var="payment">
                            <tr>
                                <td><strong>${payment.transactionId}</strong></td>
                                <td>#${payment.bookingId}</td>
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
                                <td>${payment.paymentDate}</td>
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
                                        <br>
                                        <span class="badge badge-info">
                                                Refund: ${payment.refundStatus}
                                            </span>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${payment.paymentStatus == 'Approved' && !payment.refundRequested}">
                                        <a href="${pageContext.request.contextPath}/refundRequest?paymentId=${payment.paymentId}"
                                           class="btn btn-sm btn-warning" title="Request Refund">
                                            <i class="fas fa-undo"></i> Refund
                                        </a>
                                    </c:if>

                                    <c:if test="${sessionScope.userRole == 'ADMIN' && payment.paymentStatus == 'Pending'}">
                                        <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                            <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                            <input type="hidden" name="action" value="approve_payment">
                                            <button type="submit" class="btn btn-sm btn-success" title="Approve">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                            <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                            <input type="hidden" name="action" value="reject_payment">
                                            <button type="submit" class="btn btn-sm btn-danger" title="Reject">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${sessionScope.userRole == 'ADMIN' && payment.refundRequested && payment.refundStatus == 'Pending'}">
                                        <form action="${pageContext.request.contextPath}/admin/approvePayment" method="POST" style="display:inline;">
                                            <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                            <input type="hidden" name="action" value="approve_refund">
                                            <button type="submit" class="btn btn-sm btn-success" title="Approve Refund">
                                                <i class="fas fa-check"></i> Approve Refund
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-receipt"></i>
                        <h3>No payment records found</h3>
                        <p>Your payment history will appear here</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
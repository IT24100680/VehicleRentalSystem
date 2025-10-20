<%@ include file="../common/header.jsp" %>

<div class="payment-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/viewBookings" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Bookings
        </a>

        <h1><i class="fas fa-credit-card"></i> Make Payment</h1>

        <div class="payment-layout">
            <!-- Payment Form -->
            <div class="payment-form-section">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-lock"></i> Secure Payment</h3>
                    </div>

                    <c:if test="${errorMessage != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/createPayment" method="POST"
                          onsubmit="return validatePayment()" class="payment-form">

                        <input type="hidden" name="bookingId" value="${booking.bookingId}">

                        <div class="form-group">
                            <label for="paymentMethod">
                                <i class="fas fa-wallet"></i> Payment Method *
                            </label>
                            <select id="paymentMethod" name="paymentMethod" class="form-control"
                                    required onchange="togglePaymentFields()">
                                <option value="">Select Payment Method</option>
                                <option value="Credit Card">Credit Card</option>
                                <option value="Debit Card">Debit Card</option>
                                <option value="PayPal">PayPal</option>
                                <option value="Bank Transfer">Bank Transfer</option>
                            </select>
                        </div>

                        <div id="cardFields" style="display: none;">
                            <div class="form-group">
                                <label for="cardHolderName">
                                    <i class="fas fa-user"></i> Card Holder Name *
                                </label>
                                <input type="text" id="cardHolderName" name="cardHolderName"
                                       class="form-control" placeholder="John Doe">
                            </div>

                            <div class="form-group">
                                <label for="cardNumber">
                                    <i class="fas fa-credit-card"></i> Card Number *
                                </label>
                                <input type="text" id="cardNumber" name="cardNumber"
                                       class="form-control" placeholder="1234567890123456"
                                       maxlength="19" pattern="[0-9\s]{13,19}">
                                <small class="form-text">Enter 16-digit card number</small>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="expiryDate">
                                        <i class="fas fa-calendar"></i> Expiry Date *
                                    </label>
                                    <input type="month" id="expiryDate" name="expiryDate"
                                           class="form-control">
                                </div>

                                <div class="form-group">
                                    <label for="cvv">
                                        <i class="fas fa-lock"></i> CVV *
                                    </label>
                                    <input type="password" id="cvv" name="cvv"
                                           class="form-control" placeholder="123"
                                           maxlength="3" pattern="[0-9]{3}">
                                </div>
                            </div>
                        </div>

                        <div id="paypalFields" style="display: none;">
                            <div class="form-group">
                                <label for="paypalEmail">
                                    <i class="fab fa-paypal"></i> PayPal Email *
                                </label>
                                <input type="email" id="paypalEmail" name="paypalEmail"
                                       class="form-control" placeholder="your@email.com">
                            </div>
                        </div>

                        <div id="bankFields" style="display: none;">
                            <div class="form-group">
                                <label for="accountNumber">
                                    <i class="fas fa-university"></i> Account Number *
                                </label>
                                <input type="text" id="accountNumber" name="accountNumber"
                                       class="form-control" placeholder="Enter account number">
                            </div>

                            <div class="form-group">
                                <label for="bankName">
                                    <i class="fas fa-building"></i> Bank Name *
                                </label>
                                <input type="text" id="bankName" name="bankName"
                                       class="form-control" placeholder="Enter bank name">
                            </div>
                        </div>

                        <div class="payment-security">
                            <i class="fas fa-shield-alt"></i>
                            <span>Your payment information is encrypted and secure</span>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/viewBookings"
                               class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-success btn-large">
                                <i class="fas fa-check-circle"></i> Pay $${booking.totalAmount}
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Booking Summary -->
            <div class="payment-sidebar">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-file-invoice"></i> Booking Summary</h3>
                    </div>
                    <div class="booking-summary-details">
                        <div class="summary-item">
                            <strong>Booking ID:</strong>
                            <span>#${booking.bookingId}</span>
                        </div>

                        <div class="summary-item">
                            <strong>Vehicle:</strong>
                            <span>${booking.vehicleName}</span>
                        </div>

                        <div class="summary-item">
                            <strong>Pickup Date:</strong>
                            <span>${booking.startDate}</span>
                        </div>

                        <div class="summary-item">
                            <strong>Return Date:</strong>
                            <span>${booking.endDate}</span>
                        </div>

                        <div class="summary-item">
                            <strong>Duration:</strong>
                            <span>${booking.totalDays} days</span>
                        </div>

                        <div class="summary-item">
                            <strong>Pickup Location:</strong>
                            <span>${booking.pickupLocation}</span>
                        </div>

                        <div class="summary-item">
                            <strong>Drop-off Location:</strong>
                            <span>${booking.dropoffLocation}</span>
                        </div>

                        <hr>

                        <div class="summary-item total">
                            <strong>Total Amount:</strong>
                            <span class="amount">$${booking.totalAmount}</span>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-shield-alt"></i> Payment Security</h3>
                    </div>
                    <ul class="security-list">
                        <li><i class="fas fa-check-circle"></i> SSL Encrypted Connection</li>
                        <li><i class="fas fa-check-circle"></i> PCI DSS Compliant</li>
                        <li><i class="fas fa-check-circle"></i> 100% Secure Transactions</li>
                        <li><i class="fas fa-check-circle"></i> Fraud Protection</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function togglePaymentFields() {
        const method = document.getElementById('paymentMethod').value;
        const cardFields = document.getElementById('cardFields');
        const paypalFields = document.getElementById('paypalFields');
        const bankFields = document.getElementById('bankFields');

        // Hide all fields
        cardFields.style.display = 'none';
        paypalFields.style.display = 'none';
        bankFields.style.display = 'none';

        // Show relevant fields
        if (method === 'Credit Card' || method === 'Debit Card') {
            cardFields.style.display = 'block';
            document.getElementById('cardHolderName').required = true;
            document.getElementById('cardNumber').required = true;
            document.getElementById('expiryDate').required = true;
            document.getElementById('cvv').required = true;
        } else if (method === 'PayPal') {
            paypalFields.style.display = 'block';
            document.getElementById('paypalEmail').required = true;
        } else if (method === 'Bank Transfer') {
            bankFields.style.display = 'block';
            document.getElementById('accountNumber').required = true;
            document.getElementById('bankName').required = true;
        }
    }

    function validatePayment() {
        const method = document.getElementById('paymentMethod').value;

        if (!method) {
            alert('Please select a payment method!');
            return false;
        }

        if (method === 'Credit Card' || method === 'Debit Card') {
            const cardNumber = document.getElementById('cardNumber').value.replace(/\s/g, '');
            if (cardNumber.length !== 16) {
                alert('Card number must be 16 digits!');
                return false;
            }
        }

        return confirm('Confirm payment of $${booking.totalAmount}?');
    }
</script>

<style>
    .payment-layout {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 2rem;
        margin-top: 2rem;
    }

    .payment-security {
        background: var(--light);
        padding: 1rem;
        border-radius: var(--radius-md);
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin: 1.5rem 0;
        color: var(--success-color);
    }

    .booking-summary-details {
        padding: 1.5rem;
    }

    .summary-item {
        display: flex;
        justify-content: space-between;
        padding: 0.75rem 0;
        border-bottom: 1px solid var(--light);
    }

    .summary-item.total {
        border-top: 2px solid var(--primary-color);
        border-bottom: none;
        margin-top: 1rem;
        padding-top: 1rem;
        font-size: 1.2rem;
    }

    .summary-item .amount {
        color: var(--primary-color);
        font-weight: 700;
        font-size: 1.5rem;
    }

    .security-list {
        list-style: none;
        padding: 1.5rem;
    }

    .security-list li {
        padding: 0.5rem 0;
        color: var(--success-color);
    }

    @media (max-width: 768px) {
        .payment-layout {
            grid-template-columns: 1fr;
        }
    }
</style>

<%@ include file="../common/footer.jsp" %>
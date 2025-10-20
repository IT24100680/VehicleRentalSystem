<%@ include file="../common/header.jsp" %>

<div class="feedback-list-container">
    <div class="container">
        <div class="section-header">
            <h1><i class="fas fa-star"></i> Customer Reviews</h1>
            <c:if test="${sessionScope.loggedInUser != null && sessionScope.userRole == 'CUSTOMER'}">
                <a href="${pageContext.request.contextPath}/selectBookingForFeedback" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add Review
                </a>
            </c:if>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <c:choose>
                    <c:when test="${param.success == 'added'}">Feedback submitted successfully!</c:when>
                    <c:when test="${param.success == 'updated'}">Feedback updated successfully!</c:when>
                    <c:when test="${param.success == 'deleted'}">Feedback deleted successfully!</c:when>
                </c:choose>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${feedbacks != null && feedbacks.size() > 0}">
                <div class="feedback-grid">
                    <c:forEach items="${feedbacks}" var="feedback">
                        <div class="feedback-card">
                            <div class="feedback-header">
                                <div class="user-info">
                                    <div class="avatar">
                                        <i class="fas fa-user-circle"></i>
                                    </div>
                                    <div>
                                        <h4>${feedback.anonymous ? 'Anonymous User' : feedback.userName}</h4>
                                        <small>${feedback.feedbackDate}</small>
                                    </div>
                                </div>
                                <div class="rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= feedback.rating ? 'active' : ''}"></i>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="feedback-body">
                                <p class="vehicle-name">
                                    <i class="fas fa-car"></i> ${feedback.vehicleName}
                                </p>
                                <p class="feedback-comment">${feedback.comments}</p>
                            </div>

                            <c:if test="${sessionScope.userId == feedback.userId || sessionScope.userRole == 'ADMIN'}">
                                <div class="feedback-actions">
                                    <c:if test="${sessionScope.userId == feedback.userId}">
                                        <a href="${pageContext.request.contextPath}/editFeedback?id=${feedback.feedbackId}"
                                           class="btn btn-sm btn-warning">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/deleteFeedback" method="POST"
                                          style="display:inline;" onsubmit="return confirmDelete('Are you sure you want to delete this feedback?')">
                                        <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-comment-slash"></i>
                    <h3>No reviews yet</h3>
                    <p>Be the first to share your experience!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<style>
    .feedback-list-container {
        padding: 3rem 0;
    }

    .feedback-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 2rem;
        margin-top: 2rem;
    }

    .feedback-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        padding: 1.5rem;
        transition: var(--transition);
    }

    .feedback-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-lg);
    }

    .feedback-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 1rem;
    }

    .user-info {
        display: flex;
        gap: 1rem;
        align-items: center;
    }

    .avatar {
        font-size: 3rem;
        color: var(--primary-color);
    }

    .user-info h4 {
        margin-bottom: 0.25rem;
    }

    .user-info small {
        color: var(--gray);
    }

    .rating i {
        color: var(--gray-light);
        font-size: 1.2rem;
    }

    .rating i.active {
        color: var(--warning-color);
    }

    .feedback-body {
        margin: 1.5rem 0;
    }

    .vehicle-name {
        color: var(--primary-color);
        font-weight: 600;
        margin-bottom: 1rem;
    }

    .feedback-comment {
        color: var(--dark);
        line-height: 1.6;
    }

    .feedback-actions {
        display: flex;
        gap: 0.5rem;
        padding-top: 1rem;
        border-top: 1px solid var(--light);
    }
</style>

<%@ include file="../common/footer.jsp" %>
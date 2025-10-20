<!-- FILE: src/main/webapp/jsp/admin/manageFeedbacks.jsp -->

<%@ page import="com.vehiclerental.dao.FeedbackDAO" %>
<%@ page import="com.vehiclerental.model.Feedback" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    List<Feedback> allFeedbacks = feedbackDAO.getAllFeedbacks();
    request.setAttribute("allFeedbacks", allFeedbacks);
%>

<%@ include file="../common/header.jsp" %>

<div class="admin-container">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-header">
            <h1><i class="fas fa-star"></i> Manage Feedbacks</h1>
        </div>

        <c:if test="${param.success != null}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                Feedback deleted successfully!
            </div>
        </c:if>

        <!-- Statistics -->
        <div class="stats-grid" style="margin-bottom: 2rem;">
            <div class="stat-card stat-primary">
                <div class="stat-icon">
                    <i class="fas fa-comments"></i>
                </div>
                <div class="stat-details">
                    <p>Total Reviews</p>
                    <h2>${allFeedbacks.size()}</h2>
                </div>
            </div>

            <div class="stat-card stat-success">
                <div class="stat-icon">
                    <i class="fas fa-star"></i>
                </div>
                <div class="stat-details">
                    <p>5 Star Reviews</p>
                    <h2>
                        <c:set var="fiveStar" value="0"/>
                        <c:forEach items="${allFeedbacks}" var="f">
                            <c:if test="${f.rating == 5}">
                                <c:set var="fiveStar" value="${fiveStar + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${fiveStar}
                    </h2>
                </div>
            </div>

            <div class="stat-card stat-info">
                <div class="stat-icon">
                    <i class="fas fa-user-secret"></i>
                </div>
                <div class="stat-details">
                    <p>Anonymous Reviews</p>
                    <h2>
                        <c:set var="anonymous" value="0"/>
                        <c:forEach items="${allFeedbacks}" var="f">
                            <c:if test="${f.anonymous}">
                                <c:set var="anonymous" value="${anonymous + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${anonymous}
                    </h2>
                </div>
            </div>
        </div>

        <!-- Feedbacks Grid -->
        <div class="feedbacks-admin-grid">
            <c:forEach items="${allFeedbacks}" var="feedback">
                <div class="feedback-admin-card">
                    <div class="feedback-admin-header">
                        <div class="user-info">
                            <i class="fas fa-user-circle avatar-icon"></i>
                            <div>
                                <h4>${feedback.anonymous ? 'Anonymous User' : feedback.userName}</h4>
                                <small><fmt:formatDate value="${feedback.feedbackDate}" pattern="MMM dd, yyyy"/></small>
                            </div>
                        </div>
                        <div class="rating-display">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= feedback.rating ? 'star-filled' : 'star-empty'}"></i>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="feedback-admin-body">
                        <p class="vehicle-name">
                            <i class="fas fa-car"></i> ${feedback.vehicleName}
                        </p>
                        <p class="feedback-text">${feedback.comments}</p>
                    </div>

                    <div class="feedback-admin-footer">
                        <span class="feedback-id">ID: #${feedback.feedbackId}</span>
                        <div class="action-buttons">
                            <form action="${pageContext.request.contextPath}/deleteFeedback" method="POST"
                                  style="display:inline;" onsubmit="return confirmDelete('Delete this feedback?')">
                                <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
                                <button type="submit" class="btn btn-sm btn-danger">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${allFeedbacks.size() == 0}">
            <div class="empty-state">
                <i class="fas fa-comment-slash"></i>
                <h3>No feedbacks yet</h3>
                <p>Customer reviews will appear here</p>
            </div>
        </c:if>
    </div>
</div>

<style>
    .feedbacks-admin-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 2rem;
    }

    .feedback-admin-card {
        background: var(--white);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        overflow: hidden;
        transition: var(--transition);
    }

    .feedback-admin-card:hover {
        box-shadow: var(--shadow-lg);
    }

    .feedback-admin-header {
        padding: 1.5rem;
        border-bottom: 2px solid var(--light);
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
    }

    .user-info {
        display: flex;
        gap: 1rem;
    }

    .avatar-icon {
        font-size: 3rem;
        color: var(--primary-color);
    }

    .user-info h4 {
        margin: 0;
        color: var(--dark);
    }

    .user-info small {
        color: var(--gray);
    }

    .rating-display {
        display: flex;
        gap: 0.2rem;
    }

    .star-filled {
        color: var(--warning-color);
    }

    .star-empty {
        color: var(--gray-light);
    }

    .feedback-admin-body {
        padding: 1.5rem;
    }

    .vehicle-name {
        color: var(--primary-color);
        font-weight: 600;
        margin-bottom: 1rem;
    }

    .feedback-text {
        color: var(--dark);
        line-height: 1.6;
    }

    .feedback-admin-footer {
        padding: 1rem 1.5rem;
        background: var(--light);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .feedback-id {
        color: var(--gray);
        font-size: 0.9rem;
        font-weight: 600;
    }
</style>

<%@ include file="../common/footer.jsp" %>
<%@ include file="../common/header.jsp" %>

<div class="feedback-container">
    <div class="container">
        <a href="${pageContext.request.contextPath}/viewFeedback" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Feedbacks
        </a>

        <div class="feedback-box">
            <div class="card">
                <div class="card-header">
                    <h2><i class="fas fa-edit"></i> Edit Your Feedback</h2>
                </div>

                <div class="card-body">
                    <c:if test="${errorMessage != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/editFeedback" method="POST" class="feedback-form">
                        <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">

                        <div class="form-group">
                            <label>
                                <i class="fas fa-star"></i> Your Rating *
                            </label>
                            <div class="star-rating">
                                <input type="radio" id="star5" name="rating" value="5" ${feedback.rating == 5 ? 'checked' : ''} required>
                                <label for="star5" title="5 stars"><i class="fas fa-star"></i></label>

                                <input type="radio" id="star4" name="rating" value="4" ${feedback.rating == 4 ? 'checked' : ''}>
                                <label for="star4" title="4 stars"><i class="fas fa-star"></i></label>

                                <input type="radio" id="star3" name="rating" value="3" ${feedback.rating == 3 ? 'checked' : ''}>
                                <label for="star3" title="3 stars"><i class="fas fa-star"></i></label>

                                <input type="radio" id="star2" name="rating" value="2" ${feedback.rating == 2 ? 'checked' : ''}>
                                <label for="star2" title="2 stars"><i class="fas fa-star"></i></label>

                                <input type="radio" id="star1" name="rating" value="1" ${feedback.rating == 1 ? 'checked' : ''}>
                                <label for="star1" title="1 star"><i class="fas fa-star"></i></label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="comments">
                                <i class="fas fa-comment"></i> Your Review *
                            </label>
                            <textarea id="comments" name="comments" class="form-control" rows="6"
                                      required>${feedback.comments}</textarea>
                        </div>

                        <div class="form-group">
                            <label class="checkbox-label">
                                <input type="checkbox" name="isAnonymous" value="true" ${feedback.anonymous ? 'checked' : ''}>
                                <span>Post as Anonymous</span>
                            </label>
                        </div>

                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/viewFeedback" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Update Feedback
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .feedback-container {
        padding: 3rem 0;
    }

    .feedback-box {
        max-width: 800px;
        margin: 2rem auto;
    }

    .star-rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: flex-end;
        gap: 0.5rem;
        font-size: 2.5rem;
    }

    .star-rating input {
        display: none;
    }

    .star-rating label {
        cursor: pointer;
        color: var(--gray-light);
        transition: var(--transition);
    }

    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label {
        color: var(--warning-color);
    }
</style>

<%@ include file="../common/footer.jsp" %>
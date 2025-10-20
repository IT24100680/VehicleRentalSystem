<%@ include file="jsp/common/header.jsp" %>

<!-- Hero Section -->
<section class="hero" style="background-image: url('${pageContext.request.contextPath}/assets/images/vehicles/aaa.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat;">
    <div class="hero-overlay"></div>
    <div class="hero-content animate__animated animate__fadeInDown">
        <img src="${pageContext.request.contextPath}/assets/images/vehicles/aaa.jpg" alt="Featured Vehicle" style="max-width: 400px; height: auto; margin-bottom: 2rem; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);">
        <h1>Perfect Ride</h1>
        <p>Rent premium vehicles at unbeatable prices. Fast, easy, and reliable.</p>
        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                <i class="fas fa-sign-in-alt"></i> Login to Browse Vehicles
            </a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary">
                <i class="fas fa-user-plus"></i> Get Started
            </a>
        </div>
    </div>
</section>


<!-- Features Section -->
<section class="features">
    <div class="container">
        <h2 class="section-title">Why Choose Us?</h2>
        <div class="features-grid">
            <div class="feature-card animate__animated animate__fadeInUp">
                <div class="feature-icon">
                    <i class="fas fa-car-side"></i>
                </div>
                <h3>Wide Selection</h3>
                <p>Choose from our extensive fleet of well-maintained vehicles</p>
            </div>

            <div class="feature-card animate__animated animate__fadeInUp" style="animation-delay: 0.1s">
                <div class="feature-icon">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <h3>Best Prices</h3>
                <p>Competitive rates with no hidden charges</p>
            </div>

            <div class="feature-card animate__animated animate__fadeInUp" style="animation-delay: 0.2s">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3>Insurance Included</h3>
                <p>Comprehensive insurance coverage for your peace of mind</p>
            </div>

            <div class="feature-card animate__animated animate__fadeInUp" style="animation-delay: 0.3s">
                <div class="feature-icon">
                    <i class="fas fa-headset"></i>
                </div>
                <h3>24/7 Support</h3>
                <p>Round-the-clock customer service for any assistance</p>
            </div>
        </div>
    </div>
</section>

<!-- Featured Vehicles -->
<section class="featured-vehicles">
    <div class="container">
        <h2 class="section-title">Featured Vehicles</h2>
        <div class="vehicle-grid">
            <!-- Sample Vehicle Cards - Will be populated from database -->
            <div class="vehicle-card">
                <div class="vehicle-image">
                    <img src="https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Toyota+Camry+2023" alt="Vehicle">
                    <span class="badge badge-available">Available</span>
                </div>
                <div class="vehicle-info">
                    <h3>Toyota Camry 2023</h3>
                    <div class="vehicle-meta">
                        <span><i class="fas fa-users"></i> 5 Seats</span>
                        <span><i class="fas fa-cog"></i> Automatic</span>
                        <span><i class="fas fa-gas-pump"></i> Hybrid</span>
                    </div>
                    <div class="vehicle-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                        <span>(4.5)</span>
                    </div>
                    <div class="vehicle-footer">
                        <div class="price">$75<span>/day</span></div>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary">Login to View Details</a>
                    </div>
                </div>
            </div>

            <!-- More vehicle cards... -->
        </div>
    </div>
</section>

<!-- Statistics Section -->
<section class="statistics">
    <div class="container">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-car"></i>
                </div>
                <h3 class="stat-number" data-target="500">0</h3>
                <p>Vehicles Available</p>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="stat-number" data-target="5000">0</h3>
                <p>Happy Customers</p>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-map-marker-alt"></i>
                </div>
                <h3 class="stat-number" data-target="50">0</h3>
                <p>Locations</p>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <h3 class="stat-number" data-target="24">0</h3>
                <p>Hours Service</p>
            </div>
        </div>
    </div>
</section>

<!-- Testimonials -->
<section class="testimonials">
    <div class="container">
        <h2 class="section-title">What Our Customers Say</h2>
        <div class="testimonial-grid">
            <div class="testimonial-card">
                <div class="testimonial-header">
                    <img src="https://via.placeholder.com/100x100/2196F3/FFFFFF?text=John+Doe" alt="User">
                    <div>
                        <h4>John Doe</h4>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                    </div>
                </div>
                <p>"Excellent service! The car was clean, well-maintained, and the booking process was seamless."</p>
            </div>

            <div class="testimonial-card">
                <div class="testimonial-header">
                    <img src="https://via.placeholder.com/100x100/E91E63/FFFFFF?text=Jane+Smith" alt="User">
                    <div>
                        <h4>Jane Smith</h4>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                    </div>
                </div>
                <p>"Great prices and fantastic customer support. Highly recommend!"</p>
            </div>

            <div class="testimonial-card">
                <div class="testimonial-header">
                    <img src="https://via.placeholder.com/100x100/FF9800/FFFFFF?text=Mike+Johnson" alt="User">
                    <div>
                        <h4>Mike Johnson</h4>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                        </div>
                    </div>
                </div>
                <p>"Professional service from start to finish. Will definitely rent again!"</p>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <div class="cta-content">
            <h2>Ready to Hit the Road?</h2>
            <p>Book your vehicle today and enjoy the journey!</p>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-large btn-white">
                <i class="fas fa-rocket"></i> Get Started Now
            </a>
        </div>
    </div>
</section>

<%@ include file="jsp/common/footer.jsp" %>
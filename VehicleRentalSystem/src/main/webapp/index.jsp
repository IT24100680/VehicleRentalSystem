<%@ include file="jsp/common/header.jsp" %>

<!-- Hero Section -->
<section class="hero" style="
        position: relative;
        width: 100%;
        height: 100vh;
        background: url('${pageContext.request.contextPath}/assets/images/banner.jpg') no-repeat center center/cover;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        ">
    <div class="hero-overlay" style="
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
    "></div>

    <div class="hero-content animate__animated animate__fadeInDown" style="
        position: relative;
        z-index: 1;
        text-align: center;
        top: -100px; /* moved text upward by 100px */
    ">
        <h1 style="
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1rem;
        ">Find Your Perfect Ride</h1>

        <p style="
            font-size: 1.25rem;
            margin-bottom: 2rem;
        ">Rent premium vehicles at unbeatable prices. Fast, easy, and reliable.</p>

        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="
                margin-right: 1rem;
                padding: 0.75rem 1.5rem;
                font-size: 1rem;
                border-radius: 8px;
                background-color: #007bff;
                color: white;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            ">
                <i class="fas fa-sign-in-alt"></i> Login to Browse Vehicles
            </a>

            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary" style="
                padding: 0.75rem 1.5rem;
                font-size: 1rem;
                border-radius: 8px;
                background-color: #6c757d;
                color: white;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            ">
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
<section class="featured-vehicles" style="
    padding: 80px 0;
    background-color: #f9f9f9;
">
    <div class="container" style="
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    ">
        <h2 class="section-title" style="
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 50px;
        ">Featured Vehicles</h2>

        <div class="vehicle-grid" style="
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            justify-content: center;
        ">

            <!-- Vehicle Card -->
            <div class="vehicle-card" style="
                width: 400px;
                height: 400px;
                background: white;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                display: flex;
                flex-direction: column;
            "
                 onmouseover="this.style.transform='translateY(-8px)'; this.style.boxShadow='0 6px 16px rgba(0,0,0,0.2)';"
                 onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 12px rgba(0,0,0,0.1)';">

                <!-- Image -->
                <div class="vehicle-image" style="position: relative; height: 55%;">
                    <img src="${pageContext.request.contextPath}/assets/images/toyota_camry_2023.jpg"
                         alt="Toyota Camry 2023"
                         style="width: 100%; height: 100%; object-fit: cover;">
                    <span class="badge badge-available" style="
                        position: absolute;
                        top: 10px;
                        left: 10px;
                        background: #28a745;
                        color: white;
                        padding: 5px 10px;
                        border-radius: 5px;
                        font-size: 0.9rem;
                        font-weight: 600;
                    ">Available</span>
                </div>

                <!-- Info -->
                <div class="vehicle-info" style="padding: 15px; flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 8px; color: #222;">Toyota Camry 2023</h3>

                        <div class="vehicle-meta" style="color: #555; font-size: 0.9rem; margin-bottom: 10px;">
                            <span style="margin-right: 10px;"><i class="fas fa-users"></i> 5 Seats</span>
                            <span style="margin-right: 10px;"><i class="fas fa-cog"></i> Auto</span>
                            <span><i class="fas fa-gas-pump"></i> Hybrid</span>
                        </div>

                        <div class="vehicle-rating" style="color: #FFD700; margin-bottom: 10px;">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                            <span style="color: #555;">(4.5)</span>
                        </div>
                    </div>

                    <!-- Footer -->
                    <div class="vehicle-footer" style="
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    ">
                        <div class="price" style="font-size: 1.2rem; font-weight: 700; color: #007bff;">
                            $75<span style="font-size: 0.9rem; color: #555;">/day</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/login" style="
                            background-color: #007bff;
                            color: white;
                            padding: 8px 15px;
                            border-radius: 6px;
                            font-size: 0.9rem;
                            text-decoration: none;
                        ">Login to View</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>



<!-- Compact Statistics Section -->
<section class="statistics" style="background:#f8f9fa; padding:40px 0;">
    <div class="container" style="max-width:1200px; margin:0 auto; padding:0 15px;">
        <div class="stats-grid" style="display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:15px;">

            <!-- Stat Card 1 -->
            <div class="stat-card" style="background:white; border-radius:10px; box-shadow:0 3px 6px rgba(0,0,0,0.1); text-align:center; padding:20px 10px;">
                <div class="stat-icon" style="font-size:32px; color:#007bff; margin-bottom:10px;">
                    <i class="fas fa-car"></i>
                </div>
                <h3 class="stat-number" data-target="500" style="font-size:2rem; margin:5px 0; color:#333;">0</h3>
                <p style="color:#666; font-size:0.9rem; margin:0;">Vehicles Available</p>
            </div>

            <!-- Stat Card 2 -->
            <div class="stat-card" style="background:white; border-radius:10px; box-shadow:0 3px 6px rgba(0,0,0,0.1); text-align:center; padding:20px 10px;">
                <div class="stat-icon" style="font-size:32px; color:#28a745; margin-bottom:10px;">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="stat-number" data-target="5000" style="font-size:2rem; margin:5px 0; color:#333;">0</h3>
                <p style="color:#666; font-size:0.9rem; margin:0;">Happy Customers</p>
            </div>

            <!-- Stat Card 3 -->
            <div class="stat-card" style="background:white; border-radius:10px; box-shadow:0 3px 6px rgba(0,0,0,0.1); text-align:center; padding:20px 10px;">
                <div class="stat-icon" style="font-size:32px; color:#ff9800; margin-bottom:10px;">
                    <i class="fas fa-map-marker-alt"></i>
                </div>
                <h3 class="stat-number" data-target="50" style="font-size:2rem; margin:5px 0; color:#333;">0</h3>
                <p style="color:#666; font-size:0.9rem; margin:0;">Locations</p>
            </div>

            <!-- Stat Card 4 -->
            <div class="stat-card" style="background:white; border-radius:10px; box-shadow:0 3px 6px rgba(0,0,0,0.1); text-align:center; padding:20px 10px;">
                <div class="stat-icon" style="font-size:32px; color:#17a2b8; margin-bottom:10px;">
                    <i class="fas fa-clock"></i>
                </div>
                <h3 class="stat-number" data-target="24" style="font-size:2rem; margin:5px 0; color:#333;">0</h3>
                <p style="color:#666; font-size:0.9rem; margin:0;">Hours Service</p>
            </div>

        </div>
    </div>
</section>



<!-- Testimonials -->
<section class="testimonials" style="
    background-color: #f8f9fa;
    padding: 60px 0;
">
    <div class="container" style="
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    ">
        <h2 class="section-title" style="
            text-align: center;
            margin-bottom: 40px;
            font-size: 2rem;
            color: #333;
        ">What Our Customers Say</h2>

        <div class="testimonial-grid" style="
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        ">

            <!-- Testimonial 1 -->
            <div class="testimonial-card" style="
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                padding: 25px;
                transition: transform 0.3s ease;
            ">
                <div class="testimonial-header" style="
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    margin-bottom: 15px;
                ">
                    <img src="${pageContext.request.contextPath}/assets/images/john.jpg"
                         alt="John Doe"
                         style="width: 70px; height: 70px; border-radius: 50%; object-fit: cover;">
                    <div>
                        <h4 style="margin: 0; color: #333;">John Doe</h4>
                        <div class="rating" style="color: #FFD700;">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                    </div>
                </div>
                <p style="color: #555; font-size: 1rem;">"Excellent service! The car was clean, well-maintained, and the booking process was seamless."</p>
            </div>

            <!-- Testimonial 2 -->
            <div class="testimonial-card" style="
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                padding: 25px;
                transition: transform 0.3s ease;
            ">
                <div class="testimonial-header" style="
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    margin-bottom: 15px;
                ">
                    <img src="${pageContext.request.contextPath}/assets/images/jane.jpg"
                         alt="Jane Smith"
                         style="width: 70px; height: 70px; border-radius: 50%; object-fit: cover;">
                    <div>
                        <h4 style="margin: 0; color: #333;">Jane Smith</h4>
                        <div class="rating" style="color: #FFD700;">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                    </div>
                </div>
                <p style="color: #555; font-size: 1rem;">"Great prices and fantastic customer support. Highly recommend!"</p>
            </div>

            <!-- Testimonial 3 -->
            <div class="testimonial-card" style="
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                padding: 25px;
                transition: transform 0.3s ease;
            ">
                <div class="testimonial-header" style="
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    margin-bottom: 15px;
                ">
                    <img src="${pageContext.request.contextPath}/assets/images/mike.jpg"
                         alt="Mike Johnson"
                         style="width: 70px; height: 70px; border-radius: 50%; object-fit: cover;">
                    <div>
                        <h4 style="margin: 0; color: #333;">Mike Johnson</h4>
                        <div class="rating" style="color: #FFD700;">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                        </div>
                    </div>
                </div>
                <p style="color: #555; font-size: 1rem;">"Professional service from start to finish. Will definitely rent again!"</p>
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
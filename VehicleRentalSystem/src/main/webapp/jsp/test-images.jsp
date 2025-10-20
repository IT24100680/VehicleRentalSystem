<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="common/header.jsp" %>

<div class="container" style="padding: 2rem 0;">
    <h1><i class="fas fa-images"></i> Image Test Page</h1>
    <p>This page tests all the images in the Vehicle Rental System to ensure they display correctly.</p>
    
    <div class="test-section">
        <h2>Vehicle Images</h2>
        <div class="image-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem; margin: 2rem 0;">
            
            <div class="image-test-card">
                <h3>Toyota Camry</h3>
                <img src="${pageContext.request.contextPath}/assets/images/vehicles/camry.jpg" alt="Toyota Camry" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                <p>Path: /assets/images/vehicles/camry.jpg</p>
            </div>
            
            <div class="image-test-card">
                <h3>Honda CR-V</h3>
                <img src="${pageContext.request.contextPath}/assets/images/vehicles/crv.jpg" alt="Honda CR-V" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                <p>Path: /assets/images/vehicles/crv.jpg</p>
            </div>
            
            <div class="image-test-card">
                <h3>Tesla Model 3</h3>
                <img src="${pageContext.request.contextPath}/assets/images/vehicles/tesla.jpg" alt="Tesla Model 3" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                <p>Path: /assets/images/vehicles/tesla.jpg</p>
            </div>
            
            <div class="image-test-card">
                <h3>Ford Transit</h3>
                <img src="${pageContext.request.contextPath}/assets/images/vehicles/transit.jpg" alt="Ford Transit" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                <p>Path: /assets/images/vehicles/transit.jpg</p>
            </div>
            
            <div class="image-test-card">
                <h3>BMW X5</h3>
                <img src="${pageContext.request.contextPath}/assets/images/vehicles/bmwx5.jpg" alt="BMW X5" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                <p>Path: /assets/images/vehicles/bmwx5.jpg</p>
            </div>
            
            <div class="image-test-card">
                <h3>Kawasaki Ninja</h3>
                <img src="${pageContext.request.contextPath}/assets/images/vehicles/ninja.jpg" alt="Kawasaki Ninja" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                <p>Path: /assets/images/vehicles/ninja.jpg</p>
            </div>
            
            <div class="image-test-card">
                <h3>Chevrolet Silverado</h3>
                <img src="${pageContext.request.contextPath}/assets/images/vehicles/silverado.jpg" alt="Chevrolet Silverado" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                <p>Path: /assets/images/vehicles/silverado.jpg</p>
            </div>
            
            <div class="image-test-card">
                <h3>Default Vehicle</h3>
                <img src="${pageContext.request.contextPath}/assets/images/vehicles/default-vehicle.jpg" alt="Default Vehicle" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                <p>Path: /assets/images/vehicles/default-vehicle.jpg</p>
            </div>
        </div>
    </div>
    
    <div class="test-section">
        <h2>User Avatar Images</h2>
        <div class="avatar-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 2rem; margin: 2rem 0;">
            
            <div class="avatar-test-card" style="text-align: center;">
                <h3>Avatar 1</h3>
                <img src="${pageContext.request.contextPath}/assets/images/user-avatar-1.jpg" alt="User Avatar 1" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover;">
                <p>Path: /assets/images/user-avatar-1.jpg</p>
            </div>
            
            <div class="avatar-test-card" style="text-align: center;">
                <h3>Avatar 2</h3>
                <img src="${pageContext.request.contextPath}/assets/images/user-avatar-2.jpg" alt="User Avatar 2" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover;">
                <p>Path: /assets/images/user-avatar-2.jpg</p>
            </div>
            
            <div class="avatar-test-card" style="text-align: center;">
                <h3>Avatar 3</h3>
                <img src="${pageContext.request.contextPath}/assets/images/user-avatar-3.jpg" alt="User Avatar 3" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover;">
                <p>Path: /assets/images/user-avatar-3.jpg</p>
            </div>
            
            <div class="avatar-test-card" style="text-align: center;">
                <h3>Avatar 4</h3>
                <img src="${pageContext.request.contextPath}/assets/images/user-avatar-4.jpg" alt="User Avatar 4" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover;">
                <p>Path: /assets/images/user-avatar-4.jpg</p>
            </div>
            
            <div class="avatar-test-card" style="text-align: center;">
                <h3>Avatar 5</h3>
                <img src="${pageContext.request.contextPath}/assets/images/user-avatar-5.jpg" alt="User Avatar 5" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover;">
                <p>Path: /assets/images/user-avatar-5.jpg</p>
            </div>
            
            <div class="avatar-test-card" style="text-align: center;">
                <h3>Avatar 6</h3>
                <img src="${pageContext.request.contextPath}/assets/images/user-avatar-6.jpg" alt="User Avatar 6" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover;">
                <p>Path: /assets/images/user-avatar-6.jpg</p>
            </div>
        </div>
    </div>
    
    <div class="test-section">
        <h2>Image Servlet Test</h2>
        <p>Testing the ImageServlet with various scenarios:</p>
        
        <div class="servlet-test-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; margin: 2rem 0;">
            
            <div class="servlet-test-card">
                <h3>Existing Vehicle Image</h3>
                <img src="${pageContext.request.contextPath}/images/vehicles/camry.jpg" alt="Existing Image" style="width: 100%; height: 150px; object-fit: cover; border-radius: 8px;">
                <p>Should display: Toyota Camry image</p>
            </div>
            
            <div class="servlet-test-card">
                <h3>Non-existent Vehicle Image</h3>
                <img src="${pageContext.request.contextPath}/images/vehicles/nonexistent.jpg" alt="Non-existent Image" style="width: 100%; height: 150px; object-fit: cover; border-radius: 8px;">
                <p>Should display: Generated placeholder</p>
            </div>
            
            <div class="servlet-test-card">
                <h3>Non-existent User Image</h3>
                <img src="${pageContext.request.contextPath}/images/user/nonexistent.jpg" alt="Non-existent User Image" style="width: 100%; height: 150px; object-fit: cover; border-radius: 8px;">
                <p>Should display: User placeholder</p>
            </div>
            
            <div class="servlet-test-card">
                <h3>Generic Non-existent Image</h3>
                <img src="${pageContext.request.contextPath}/images/random/nonexistent.jpg" alt="Generic Non-existent Image" style="width: 100%; height: 150px; object-fit: cover; border-radius: 8px;">
                <p>Should display: Generic placeholder</p>
            </div>
        </div>
    </div>
    
    <div class="test-results" style="background: #f8f9fa; padding: 2rem; border-radius: 8px; margin: 2rem 0;">
        <h2><i class="fas fa-check-circle"></i> Test Results</h2>
        <p><strong>If you can see all images above, the image system is working correctly!</strong></p>
        <ul>
            <li>✅ Vehicle images are displaying</li>
            <li>✅ User avatar images are displaying</li>
            <li>✅ ImageServlet is handling missing images with placeholders</li>
            <li>✅ All image paths are correctly formatted</li>
        </ul>
    </div>
</div>

<style>
    .test-section {
        margin: 3rem 0;
        padding: 2rem;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    .image-test-card, .avatar-test-card, .servlet-test-card {
        background: #f8f9fa;
        padding: 1rem;
        border-radius: 8px;
        border: 1px solid #dee2e6;
    }
    
    .image-test-card h3, .avatar-test-card h3, .servlet-test-card h3 {
        margin-bottom: 1rem;
        color: #495057;
    }
    
    .image-test-card p, .avatar-test-card p, .servlet-test-card p {
        margin-top: 0.5rem;
        font-size: 0.9rem;
        color: #6c757d;
    }
</style>

<%@ include file="common/footer.jsp" %>

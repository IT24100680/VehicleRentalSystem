<!-- FILE: src/main/webapp/jsp/error/404.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | Vehicle Rental System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
        }

        .error-container {
            text-align: center;
            padding: 2rem;
            max-width: 600px;
        }

        .error-code {
            font-size: 10rem;
            font-weight: 700;
            line-height: 1;
            text-shadow: 0 10px 30px rgba(0,0,0,0.3);
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        .error-icon {
            font-size: 5rem;
            margin: 2rem 0;
            animation: shake 3s infinite;
        }

        @keyframes shake {
            0%, 100% { transform: rotate(0deg); }
            10%, 30%, 50%, 70%, 90% { transform: rotate(-10deg); }
            20%, 40%, 60%, 80% { transform: rotate(10deg); }
        }

        h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            background: #fff;
            color: #667eea;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .btn-home:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }

        .suggestions {
            margin-top: 3rem;
            padding: 2rem;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
        }

        .suggestions h3 {
            margin-bottom: 1rem;
        }

        .suggestions ul {
            list-style: none;
            text-align: left;
        }

        .suggestions li {
            margin-bottom: 0.5rem;
            padding-left: 1.5rem;
            position: relative;
        }

        .suggestions li:before {
            content: '→';
            position: absolute;
            left: 0;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-code">404</div>
    <div class="error-icon">
        <i class="fas fa-car-crash"></i>
    </div>
    <h1>Oops! Page Not Found</h1>
    <p>The page you're looking for seems to have taken a wrong turn!</p>

    <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">
        <i class="fas fa-home"></i> Back to Home
    </a>

    <div class="suggestions">
        <h3>You might want to try:</h3>
        <ul>
            <li><a href="${pageContext.request.contextPath}/vehicles" style="color: #fff;">Browse Vehicles</a></li>
            <li><a href="${pageContext.request.contextPath}/login" style="color: #fff;">Login to Your Account</a></li>
            <li><a href="${pageContext.request.contextPath}/viewFeedback" style="color: #fff;">Customer Reviews</a></li>
            <li><a href="${pageContext.request.contextPath}/createTicket" style="color: #fff;">Contact Support</a></li>
        </ul>
    </div>
</div>
</body>
</html>
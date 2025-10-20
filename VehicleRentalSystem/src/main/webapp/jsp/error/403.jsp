<!-- FILE: src/main/webapp/jsp/error/403.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Access Forbidden | Vehicle Rental System</title>
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
            background: linear-gradient(135deg, #e74a3b 0%, #f6c23e 100%);
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
        }

        .error-icon {
            font-size: 5rem;
            margin: 2rem 0;
            animation: swing 1s ease-in-out infinite;
        }

        @keyframes swing {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(-15deg); }
            75% { transform: rotate(15deg); }
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

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            background: #fff;
            color: #e74a3b;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }

        .access-info {
            margin-top: 3rem;
            padding: 2rem;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
        }

        .access-info h3 {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-code">403</div>
    <div class="error-icon">
        <i class="fas fa-lock"></i>
    </div>
    <h1>Access Forbidden</h1>
    <p>You don't have permission to access this resource!</p>

    <a href="${pageContext.request.contextPath}/index.jsp" class="btn">
        <i class="fas fa-home"></i> Back to Home
    </a>

    <div class="access-info">
        <h3><i class="fas fa-shield-alt"></i> Why am I seeing this?</h3>
        <p>This page is restricted to authorized users only.</p>
        <p>If you believe you should have access, please contact an administrator.</p>
    </div>
</div>
</body>
</html>
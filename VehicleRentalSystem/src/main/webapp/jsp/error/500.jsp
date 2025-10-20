<!-- FILE: src/main/webapp/jsp/error/500.jsp -->

<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Internal Server Error | Vehicle Rental System</title>
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .error-icon {
            font-size: 5rem;
            margin: 2rem 0;
            animation: spin 4s linear infinite;
        }

        @keyframes spin {
            100% { transform: rotate(360deg); }
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

        .btn-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            background: #fff;
            color: #f5576c;
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

        .error-details {
            margin-top: 3rem;
            padding: 2rem;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            text-align: left;
        }

        .error-details h3 {
            margin-bottom: 1rem;
        }

        .error-details p {
            font-size: 0.9rem;
            opacity: 0.8;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-code">500</div>
    <div class="error-icon">
        <i class="fas fa-tools"></i>
    </div>
    <h1>Internal Server Error</h1>
    <p>Something went wrong on our end. We're working to fix it!</p>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn">
            <i class="fas fa-home"></i> Go Home
        </a>
        <a href="javascript:window.location.reload()" class="btn">
            <i class="fas fa-redo"></i> Try Again
        </a>
    </div>

    <div class="error-details">
        <h3><i class="fas fa-info-circle"></i> What happened?</h3>
        <p>Our server encountered an unexpected condition that prevented it from fulfilling your request.</p>
        <p>This is usually a temporary problem. Please try again in a few moments.</p>
        <p>If the problem persists, please contact our support team.</p>
    </div>
</div>
</body>
</html>
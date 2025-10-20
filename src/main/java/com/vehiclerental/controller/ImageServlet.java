package com.vehiclerental.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {
    
    private static final String IMAGE_BASE_PATH = "/assets/images/";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String imagePath = request.getPathInfo();
        if (imagePath == null || imagePath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Remove leading slash
        if (imagePath.startsWith("/")) {
            imagePath = imagePath.substring(1);
        }
        
        // Construct full path
        String fullPath = getServletContext().getRealPath(IMAGE_BASE_PATH + imagePath);
        Path filePath = Paths.get(fullPath);
        
        // Check if file exists
        if (!Files.exists(filePath) || !Files.isRegularFile(filePath)) {
            // Serve default image
            serveDefaultImage(response, imagePath);
            return;
        }
        
        // Determine content type
        String contentType = getContentType(imagePath);
        response.setContentType(contentType);
        
        // Set cache headers
        response.setHeader("Cache-Control", "public, max-age=31536000"); // 1 year
        response.setHeader("Expires", "Thu, 31 Dec 2025 23:59:59 GMT");
        
        // Copy file to response
        try (InputStream in = Files.newInputStream(filePath);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
    
    private void serveDefaultImage(HttpServletResponse response, String imagePath) throws IOException {
        String contentType = getContentType(imagePath);
        response.setContentType(contentType);
        
        // Generate SVG placeholder based on image type
        String svgContent = generatePlaceholderSVG(imagePath);
        
        response.getWriter().write(svgContent);
    }
    
    private String generatePlaceholderSVG(String imagePath) {
        if (imagePath.contains("vehicles/")) {
            return generateVehiclePlaceholder(imagePath);
        } else if (imagePath.contains("user")) {
            return generateUserPlaceholder();
        } else {
            return generateGenericPlaceholder();
        }
    }
    
    private String generateVehiclePlaceholder(String imagePath) {
        String vehicleName = extractVehicleName(imagePath);
        return String.format(
            "<svg width=\"300\" height=\"200\" xmlns=\"http://www.w3.org/2000/svg\">" +
            "<rect width=\"300\" height=\"200\" fill=\"#e3f2fd\"/>" +
            "<rect x=\"50\" y=\"80\" width=\"200\" height=\"60\" rx=\"10\" fill=\"#1976d2\"/>" +
            "<circle cx=\"80\" cy=\"160\" r=\"15\" fill=\"#424242\"/>" +
            "<circle cx=\"220\" cy=\"160\" r=\"15\" fill=\"#424242\"/>" +
            "<rect x=\"60\" y=\"70\" width=\"180\" height=\"40\" rx=\"5\" fill=\"#1976d2\"/>" +
            "<text x=\"150\" y=\"100\" text-anchor=\"middle\" fill=\"white\" font-family=\"Arial\" font-size=\"16\" font-weight=\"bold\">%s</text>" +
            "<text x=\"150\" y=\"120\" text-anchor=\"middle\" fill=\"white\" font-family=\"Arial\" font-size=\"12\">Vehicle</text>" +
            "</svg>", vehicleName);
    }
    
    private String generateUserPlaceholder() {
        return "<svg width=\"100\" height=\"100\" xmlns=\"http://www.w3.org/2000/svg\">" +
               "<circle cx=\"50\" cy=\"50\" r=\"50\" fill=\"#e3f2fd\"/>" +
               "<circle cx=\"50\" cy=\"40\" r=\"15\" fill=\"#1976d2\"/>" +
               "<path d=\"M20 80 Q50 60 80 80\" stroke=\"#1976d2\" stroke-width=\"8\" fill=\"none\" stroke-linecap=\"round\"/>" +
               "</svg>";
    }
    
    private String generateGenericPlaceholder() {
        return "<svg width=\"300\" height=\"200\" xmlns=\"http://www.w3.org/2000/svg\">" +
               "<rect width=\"300\" height=\"200\" fill=\"#f5f5f5\"/>" +
               "<text x=\"150\" y=\"100\" text-anchor=\"middle\" fill=\"#666\" font-family=\"Arial\" font-size=\"16\">Image Not Found</text>" +
               "</svg>";
    }
    
    private String extractVehicleName(String imagePath) {
        String fileName = Paths.get(imagePath).getFileName().toString();
        return fileName.replaceAll("\\.[^.]+$", "").replaceAll("[_-]", " ");
    }
    
    private String getContentType(String imagePath) {
        String extension = imagePath.substring(imagePath.lastIndexOf('.') + 1).toLowerCase();
        switch (extension) {
            case "jpg":
            case "jpeg":
                return "image/jpeg";
            case "png":
                return "image/png";
            case "gif":
                return "image/gif";
            case "svg":
                return "image/svg+xml";
            case "webp":
                return "image/webp";
            default:
                return "image/svg+xml"; // Default to SVG for placeholders
        }
    }
}

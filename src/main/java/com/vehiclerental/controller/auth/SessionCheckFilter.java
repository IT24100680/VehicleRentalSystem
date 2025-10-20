package com.vehiclerental.controller.auth;

import com.vehiclerental.config.AppConstants;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class SessionCheckFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();

        // Check if user is logged in
        if (session == null || session.getAttribute(AppConstants.SESSION_USER_ID) == null) {
            // User not logged in - redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?redirect=" + requestURI);
            return;
        }

        // Check admin-only pages
        if (requestURI.contains("/admin/")) {
            String role = (String) session.getAttribute(AppConstants.SESSION_USER_ROLE);

            if (!AppConstants.ROLE_ADMIN.equals(role)) {
                // Not an admin - redirect to access denied
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/jsp/error/403.jsp");
                return;
            }
        }

        // User is authenticated, continue with request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
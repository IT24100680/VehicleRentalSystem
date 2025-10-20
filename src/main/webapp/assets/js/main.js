document.addEventListener('DOMContentLoaded', function() {
    // Hamburger Menu Toggle
    const hamburger = document.getElementById('hamburger');
    const navMenu = document.getElementById('navMenu');

    if (hamburger) {
        hamburger.addEventListener('click', function() {
            navMenu.classList.toggle('active');
        });
    }

    // Animated Counter
    const counters = document.querySelectorAll('.stat-number');

    const animateCounter = (counter) => {
        const target = parseInt(counter.getAttribute('data-target'));
        const increment = target / 200;
        let current = 0;

        const updateCounter = () => {
            current += increment;
            if (current < target) {
                counter.textContent = Math.ceil(current);
                requestAnimationFrame(updateCounter);
            } else {
                counter.textContent = target;
            }
        };

        updateCounter();
    };

    // Intersection Observer for counters
    const observerOptions = {
        threshold: 0.5
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateCounter(entry.target);
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    counters.forEach(counter => {
        observer.observe(counter);
    });

    // Smooth Scroll
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Auto-hide alerts
    setTimeout(() => {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);
});

// ====================================
// FORM VALIDATION
// ====================================

function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function validatePhone(phone) {
    const re = /^[0-9]{10}$/;
    return re.test(phone);
}

function validatePassword(password) {
    return password.length >= 8 && /[A-Za-z]/.test(password) && /[0-9]/.test(password);
}

// ====================================
// CONFIRMATION DIALOGS
// ====================================

function confirmDelete(message) {
    return confirm(message || 'Are you sure you want to delete this item?');
}

function confirmAction(message) {
    return confirm(message || 'Are you sure you want to proceed?');
}

// ====================================
// IMAGE PREVIEW
// ====================================

function previewImage(input, previewId) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById(previewId).src = e.target.result;
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// ====================================
// SIDEBAR TOGGLE (Mobile)
// ====================================

function toggleSidebar() {
    document.querySelector('.sidebar').classList.toggle('active');
}

// ====================================
// DATE UTILITIES
// ====================================

function setMinDate(elementId) {
    const today = new Date().toISOString().split('T')[0];
    document.getElementById(elementId).setAttribute('min', today);
}

// Set minimum date for all date inputs on page load (excluding birthday fields)
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    
    document.querySelectorAll('input[type="date"]').forEach(input => {
        // Handle birthday fields specially - allow past dates but not future dates
        const isBirthdayField = input.id === 'dateOfBirth' || 
                               input.name === 'dateOfBirth' ||
                               input.id.toLowerCase().includes('birth') ||
                               input.name.toLowerCase().includes('birth');
        
        if (isBirthdayField) {
            // Set maximum date to today for birthday fields
            if (!input.hasAttribute('max')) {
                input.setAttribute('max', today);
            }
            return;
        }
        
        // Set minimum date to today for non-birthday fields
        if (!input.hasAttribute('min')) {
            input.setAttribute('min', today);
        }
    });
});

// ====================================
// TOAST NOTIFICATIONS
// ====================================

function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' :
        type === 'error' ? 'exclamation-circle' :
            'info-circle'}"></i>
        <span>${message}</span>
    `;

    document.body.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('show');
    }, 100);

    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// ====================================
// LOADING SPINNER
// ====================================

function showLoading() {
    const loader = document.createElement('div');
    loader.id = 'loader';
    loader.className = 'loader-overlay';
    loader.innerHTML = '<div class="spinner"></div>';
    document.body.appendChild(loader);
}

function hideLoading() {
    const loader = document.getElementById('loader');
    if (loader) {
        loader.remove();
    }
}
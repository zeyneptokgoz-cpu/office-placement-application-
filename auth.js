// auth.js - Authentication Helper

// Check authentication status
function checkAuthStatus() {
    const loginData = localStorage.getItem('loginData') || sessionStorage.getItem('loginData');
    const token = localStorage.getItem('access_token') || sessionStorage.getItem('access_token');
    
    if (!loginData || !token) {
        // Not logged in
        if (!window.location.pathname.includes('login.html')) {
            window.location.href = 'login.html';
        }
        return null;
    }
    
    try {
        const data = JSON.parse(loginData);
        console.log('=== Logged in as ===');
        console.log('Username:', data.username || 'N/A');
        console.log('==================');
        return data;
    } catch (e) {
        console.error('Error parsing login data:', e);
        return null;
    }
}

// Logout function
window.logout = function() {
    // Clear all auth data
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    localStorage.removeItem('loginData');
    localStorage.removeItem('adminLoggedIn');
    
    sessionStorage.removeItem('access_token');
    sessionStorage.removeItem('refresh_token');
    sessionStorage.removeItem('loginData');
    
    console.log('Logged out successfully');
    window.location.href = 'login.html';
};

// Run check on page load
if (typeof document !== 'undefined') {
    document.addEventListener('DOMContentLoaded', function() {
        if (!window.location.pathname.includes('login.html')) {
            checkAuthStatus();
        }
    });
}
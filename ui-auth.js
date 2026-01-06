// ui-auth.js - Control UI elements based on user role
// Add this to index.html AFTER auth.js

(function() {
    function updateUIForRole() {
        const loginData = localStorage.getItem('loginData') || sessionStorage.getItem('loginData');
        
        if (!loginData) return;
        
        try {
            const userData = JSON.parse(loginData);
            
            // Hide Admin Panel link for non-admin users
            const adminLink = document.querySelector('.admin-link, a[href="admin.html"]');
            if (adminLink) {
                if (userData.role !== 'admin') {
                    adminLink.style.display = 'none';
                } else {
                    adminLink.style.display = 'inline-block';
                }
            }
            
            // Update logout button to use the global logout function
            const logoutButtons = document.querySelectorAll('.logout-btn, button[onclick*="logout"]');
            logoutButtons.forEach(btn => {
                btn.onclick = function(e) {
                    e.preventDefault();
                    window.logout();
                };
            });
            
            // Optional: Display user name somewhere
            // You can add a user info display in the header if you want
            
        } catch (error) {
            console.error('UI Auth error:', error);
        }
    }
    
    // Run when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', updateUIForRole);
    } else {
        updateUIForRole();
    }
})();
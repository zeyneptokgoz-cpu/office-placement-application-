// login.js - Complete Login System with API Integration

function showAlert(message, type) {
    const alert = document.getElementById('alert');
    if (!alert) return;
    
    alert.textContent = message;
    alert.className = `alert ${type}`;
    alert.style.display = 'block';
    
    if (type === 'success') {
        setTimeout(() => {
            alert.style.display = 'none';
        }, 1500);
    }
}

async function handleLogin(event) {
    event.preventDefault();
    
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const rememberCheckbox = document.getElementById('remember');
    
    if (!usernameInput || !passwordInput) {
        showAlert('Form error. Please refresh the page.', 'error');
        return;
    }
    
    const username = usernameInput.value.trim();
    const password = passwordInput.value;
    const remember = rememberCheckbox ? rememberCheckbox.checked : false;

    try {
        // Show loading state
        const submitBtn = event.target.querySelector('button[type="submit"]');
        const originalText = submitBtn ? submitBtn.textContent : '';
        if (submitBtn) {
            submitBtn.disabled = true;
            submitBtn.textContent = 'Logging in...';
        }

        // Call API for login
        const response = await apiService.login(username, password);
        
        // Store tokens
        apiService.storeTokens(response.access, response.refresh, remember);

        // Store user data
        const userData = {
            username: username,
            timestamp: new Date().getTime()
        };

        const storage = remember ? localStorage : sessionStorage;
        storage.setItem('loginData', JSON.stringify(userData));

        // Check if user is admin (you can extend this logic based on your needs)
        const isAdmin = username.toLowerCase().includes('admin');
        
        showAlert(`Welcome!`, 'success');

        // Redirect based on role
        setTimeout(() => {
            if (isAdmin) {
                localStorage.setItem('adminLoggedIn', 'true');
                window.location.href = 'admin.html';
            } else {
                window.location.href = 'index.html';
            }
        }, 1000);

    } catch (error) {
        console.error('Login error:', error);
        showAlert(error.message || 'Login failed. Please check your credentials.', 'error');
        
        // Reset button
        const submitBtn = event.target.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Login';
        }
    }
}

// Attach event listener when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', handleLogin);
    }
    
    // Log demo info to console
    console.log('=== Final University Login ===');
    console.log('Using Django Backend API');
    console.log('Create users via Django admin or signup endpoint');
    console.log('============================');
});

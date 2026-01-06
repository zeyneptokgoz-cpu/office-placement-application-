// API Configuration
const API_CONFIG = {
    BASE_URL: 'http://localhost:8000/api',
    ENDPOINTS: {
        // Authentication
        LOGIN: '/token/',
        REFRESH: '/token/refresh/',
        SIGNUP: '/sign-up/',
        
        // Resources
        BUILDINGS: '/buildings/',
        DEPARTMENTS: '/departments/',
        FACULTY: '/faculty/',
        OFFICES: '/offices/',
        ASSIGNMENTS: '/assignments/',
    },
    
    // Token storage keys
    TOKEN_KEY: 'access_token',
    REFRESH_TOKEN_KEY: 'refresh_token',
    USER_DATA_KEY: 'user_data'
};

// Helper function to get full URL
function getApiUrl(endpoint) {
    return API_CONFIG.BASE_URL + endpoint;
}

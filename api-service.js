// API Service - All API calls go through this service
class ApiService {
    constructor() {
        this.baseUrl = API_CONFIG.BASE_URL;
    }

    // Get stored token
    getToken() {
        return localStorage.getItem(API_CONFIG.TOKEN_KEY) || 
               sessionStorage.getItem(API_CONFIG.TOKEN_KEY);
    }

    // Get refresh token
    getRefreshToken() {
        return localStorage.getItem(API_CONFIG.REFRESH_TOKEN_KEY) || 
               sessionStorage.getItem(API_CONFIG.REFRESH_TOKEN_KEY);
    }

    // Store tokens
    storeTokens(accessToken, refreshToken, remember = false) {
        const storage = remember ? localStorage : sessionStorage;
        storage.setItem(API_CONFIG.TOKEN_KEY, accessToken);
        storage.setItem(API_CONFIG.REFRESH_TOKEN_KEY, refreshToken);
    }

    // Clear tokens
    clearTokens() {
        localStorage.removeItem(API_CONFIG.TOKEN_KEY);
        localStorage.removeItem(API_CONFIG.REFRESH_TOKEN_KEY);
        sessionStorage.removeItem(API_CONFIG.TOKEN_KEY);
        sessionStorage.removeItem(API_CONFIG.REFRESH_TOKEN_KEY);
    }

    // Generic request method
    async request(endpoint, options = {}) {
        const token = this.getToken();
        
        const headers = {
            'Content-Type': 'application/json',
            ...options.headers
        };

        // Add authorization header if token exists
        if (token && !options.skipAuth) {
            headers['Authorization'] = `Bearer ${token}`;
        }

        const config = {
            ...options,
            headers
        };

        try {
            const response = await fetch(this.baseUrl + endpoint, config);

            // Handle 401 - Try to refresh token
            if (response.status === 401 && !options.skipAuth) {
                const refreshed = await this.refreshAccessToken();
                if (refreshed) {
                    // Retry the request with new token
                    headers['Authorization'] = `Bearer ${this.getToken()}`;
                    const retryResponse = await fetch(this.baseUrl + endpoint, config);
                    return await this.handleResponse(retryResponse);
                } else {
                    // Refresh failed, logout
                    window.logout();
                    throw new Error('Session expired. Please login again.');
                }
            }

            return await this.handleResponse(response);
        } catch (error) {
            console.error('API Request Error:', error);
            throw error;
        }
    }

    // Handle API response
    async handleResponse(response) {
        const contentType = response.headers.get('content-type');
        
        if (contentType && contentType.includes('application/json')) {
            const data = await response.json();
            
            if (!response.ok) {
                throw new Error(data.detail || data.message || 'API request failed');
            }
            
            return data;
        } else {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response;
        }
    }

    // Refresh access token
    async refreshAccessToken() {
        const refreshToken = this.getRefreshToken();
        if (!refreshToken) {
            return false;
        }

        try {
            const response = await fetch(this.baseUrl + API_CONFIG.ENDPOINTS.REFRESH, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ refresh: refreshToken })
            });

            if (response.ok) {
                const data = await response.json();
                const remember = !!localStorage.getItem(API_CONFIG.REFRESH_TOKEN_KEY);
                this.storeTokens(data.access, refreshToken, remember);
                return true;
            }
            return false;
        } catch (error) {
            console.error('Token refresh failed:', error);
            return false;
        }
    }

    // Authentication APIs
    async login(username, password) {
        const response = await this.request(API_CONFIG.ENDPOINTS.LOGIN, {
            method: 'POST',
            body: JSON.stringify({ username, password }),
            skipAuth: true
        });
        return response;
    }

    async signup(userData) {
        const response = await this.request(API_CONFIG.ENDPOINTS.SIGNUP, {
            method: 'POST',
            body: JSON.stringify(userData),
            skipAuth: true
        });
        return response;
    }

    // Resource APIs
    async getBuildings() {
        return await this.request(API_CONFIG.ENDPOINTS.BUILDINGS);
    }

    async getDepartments() {
        return await this.request(API_CONFIG.ENDPOINTS.DEPARTMENTS);
    }

    async getFaculty(params = {}) {
        const queryString = new URLSearchParams(params).toString();
        const endpoint = API_CONFIG.ENDPOINTS.FACULTY + (queryString ? `?${queryString}` : '');
        return await this.request(endpoint);
    }

    async getFacultyById(id) {
        return await this.request(`${API_CONFIG.ENDPOINTS.FACULTY}${id}/`);
    }

    async getOffices(params = {}) {
        const queryString = new URLSearchParams(params).toString();
        const endpoint = API_CONFIG.ENDPOINTS.OFFICES + (queryString ? `?${queryString}` : '');
        return await this.request(endpoint);
    }

    async getOfficeById(id) {
        return await this.request(`${API_CONFIG.ENDPOINTS.OFFICES}${id}/`);
    }

    async getAssignments() {
        return await this.request(API_CONFIG.ENDPOINTS.ASSIGNMENTS);
    }

    // Combined data fetch - Get offices with their assigned faculty
    async getOfficesWithFaculty() {
        try {
            const [offices, assignments, faculty] = await Promise.all([
                this.getOffices(),
                this.getAssignments(),
                this.getFaculty()
            ]);

            // Map assignments to create office-faculty relationships
            const officesWithFaculty = offices.map(office => {
                const officeAssignments = assignments.filter(
                    assignment => assignment.office.room_id === office.room_id
                );
                
                const professors = officeAssignments.map(assignment => assignment.faculty);
                
                return {
                    ...office,
                    professors: professors
                };
            });

            return officesWithFaculty;
        } catch (error) {
            console.error('Error fetching offices with faculty:', error);
            throw error;
        }
    }
}

// Create global instance
const apiService = new ApiService();

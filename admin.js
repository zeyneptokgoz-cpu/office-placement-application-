// Admin Panel JavaScript
class AdminPanel {
    constructor() {
        this.currentTab = 'dashboard';
        this.professors = [];
        this.offices = [];
        this.assignments = [];
        this.departments = [];
        this.buildings = [];
    }

    async init() {
        // Check authentication
        const token = localStorage.getItem('access_token') || sessionStorage.getItem('access_token');
        if (!token) {
            window.location.href = 'login.html';
            return;
        }

        // Setup event listeners
        this.setupEventListeners();
        
        // Load initial data
        await this.loadAllData();
        
        // Show dashboard
        this.switchTab('dashboard');
    }

    setupEventListeners() {
        // Sidebar menu items
        document.querySelectorAll('.menu-item').forEach(item => {
            item.addEventListener('click', (e) => {
                const tab = e.currentTarget.dataset.tab;
                this.switchTab(tab);
            });
        });

        // Modal forms
        document.getElementById('professor-form')?.addEventListener('submit', (e) => {
            e.preventDefault();
            this.saveProfessor();
        });

        document.getElementById('office-form')?.addEventListener('submit', (e) => {
            e.preventDefault();
            this.saveOffice();
        });
    }

    switchTab(tabName) {
        this.currentTab = tabName;

        // Update menu items
        document.querySelectorAll('.menu-item').forEach(item => {
            item.classList.remove('active');
            if (item.dataset.tab === tabName) {
                item.classList.add('active');
            }
        });

        // Update tab content
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.remove('active');
        });
        document.getElementById(tabName)?.classList.add('active');

        // Load tab-specific data
        switch(tabName) {
            case 'dashboard':
                this.loadDashboard();
                break;
            case 'professors':
                this.loadProfessorsTable();
                break;
            case 'offices':
                this.loadOfficesTable();
                break;
            case 'equipment':
                this.loadEquipment();
                break;
            case 'schedule':
                this.loadScheduleManagement();
                break;
        }
    }

    async loadAllData() {
        try {
            const token = localStorage.getItem('access_token') || sessionStorage.getItem('access_token');
            const headers = {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            };

            // Load all data in parallel
            const [officesRes, facultyRes, assignmentsRes, buildingsRes, deptRes] = await Promise.all([
                fetch('http://localhost:8000/api/offices/', { headers }),
                fetch('http://localhost:8000/api/faculty/', { headers }),
                fetch('http://localhost:8000/api/assignments/', { headers }),
                fetch('http://localhost:8000/api/buildings/', { headers }),
                fetch('http://localhost:8000/api/departments/', { headers })
            ]);

            this.offices = await officesRes.json();
            this.professors = await facultyRes.json();
            this.assignments = await assignmentsRes.json();
            this.buildings = await buildingsRes.json();
            this.departments = await deptRes.json();

            console.log('Admin data loaded:', {
                offices: this.offices.length,
                professors: this.professors.length,
                assignments: this.assignments.length
            });

        } catch (error) {
            console.error('Error loading admin data:', error);
            alert('Failed to load data. Please refresh the page.');
        }
    }

    loadDashboard() {
        // Update stats
        document.getElementById('total-professors').textContent = this.professors.length;
        document.getElementById('total-offices').textContent = this.offices.length;
        document.getElementById('total-equipment').textContent = this.offices.reduce((sum, o) => sum + (o.capacity || 0), 0);
        document.getElementById('total-schedules').textContent = this.assignments.length;
    }

    loadProfessorsTable() {
        const tbody = document.getElementById('professors-table');
        if (!tbody) return;

        tbody.innerHTML = this.professors.map(prof => {
            // Find assignment
            const assignment = this.assignments.find(a => a.faculty.staff_id === prof.staff_id);
            const officeNum = assignment ? assignment.office.room_number : 'N/A';

            return `
                <tr>
                    <td>${prof.full_name}</td>
                    <td>${prof.department ? prof.department.name : 'N/A'}</td>
                    <td>${officeNum}</td>
                    <td>${this.generateEmail(prof.full_name)}</td>
                    <td>+90 (312) 123 45 67</td>
                    <td>
                        <button class="btn btn-sm btn-edit" onclick="admin.editProfessor(${prof.staff_id})">Edit</button>
                        <button class="btn btn-sm btn-delete" onclick="admin.deleteProfessor(${prof.staff_id})">Delete</button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    loadOfficesTable() {
        const tbody = document.getElementById('offices-table');
        if (!tbody) return;

        tbody.innerHTML = this.offices.map(office => {
            // Find professors in this office
            const officeProfs = this.assignments
                .filter(a => a.office.room_id === office.room_id)
                .map(a => a.faculty.full_name);

            return `
                <tr>
                    <td>${office.room_number}</td>
                    <td>${office.building ? office.building.name : 'N/A'}</td>
                    <td>Floor ${office.floor_id}</td>
                    <td>${officeProfs.length > 0 ? officeProfs.join(', ') : 'No professors'}</td>
                    <td>Capacity: ${office.capacity || 0}</td>
                    <td>
                        <button class="btn btn-sm btn-edit" onclick="admin.editOffice(${office.room_id})">Edit</button>
                        <button class="btn btn-sm btn-delete" onclick="admin.deleteOffice(${office.room_id})">Delete</button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    loadEquipment() {
        const grid = document.getElementById('equipment-grid');
        if (!grid) return;

        grid.innerHTML = `
            <div class="equipment-info">
                <h3>Equipment Management</h3>
                <p>Total Equipment Items: ${this.offices.reduce((sum, o) => sum + (o.capacity || 0), 0)}</p>
                <p>This feature is under development.</p>
            </div>
        `;
    }

    loadScheduleManagement() {
        const select = document.getElementById('professor-select');
        if (!select) return;

        select.innerHTML = '<option value="">Select Professor</option>' + 
            this.professors.map(p => `
                <option value="${p.staff_id}">${p.full_name}</option>
            `).join('');
    }

    // Professor CRUD
    async editProfessor(id) {
        const prof = this.professors.find(p => p.staff_id === id);
        if (!prof) return;

        document.getElementById('professor-modal-title').textContent = 'Edit Professor';
        document.getElementById('professor-id').value = prof.staff_id;
        document.getElementById('professor-name').value = prof.full_name;
        document.getElementById('professor-department').value = prof.department ? prof.department.name : '';
        document.getElementById('professor-email').value = this.generateEmail(prof.full_name);
        document.getElementById('professor-phone').value = '+90 (312) 123 45 67';

        // Load office select
        const officeSelect = document.getElementById('professor-office');
        officeSelect.innerHTML = '<option value="">Select Office</option>' + 
            this.offices.map(o => `
                <option value="${o.room_id}">${o.room_number}</option>
            `).join('');

        // Set current office
        const assignment = this.assignments.find(a => a.faculty.staff_id === id);
        if (assignment) {
            officeSelect.value = assignment.office.room_id;
        }

        document.getElementById('professor-modal').style.display = 'block';
    }

    async deleteProfessor(id) {
        if (!confirm('Are you sure you want to delete this professor?')) return;

        try {
            const token = localStorage.getItem('access_token') || sessionStorage.getItem('access_token');
            const response = await fetch(`http://localhost:8000/api/admin/faculty/${id}/`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                alert('Professor deleted successfully');
                await this.loadAllData();
                this.loadProfessorsTable();
            } else {
                throw new Error('Delete failed');
            }
        } catch (error) {
            console.error('Error deleting professor:', error);
            alert('Failed to delete professor');
        }
    }

    async saveProfessor() {
        const id = document.getElementById('professor-id').value;
        const name = document.getElementById('professor-name').value;
        const department = document.getElementById('professor-department').value;
        const officeId = document.getElementById('professor-office').value;

        const token = localStorage.getItem('access_token') || sessionStorage.getItem('access_token');
        const method = id ? 'PUT' : 'POST';
        const url = id 
            ? `http://localhost:8000/api/admin/faculty/${id}/`
            : `http://localhost:8000/api/admin/faculty/`;

        try {
            // For now, just close modal and reload
            alert('Faculty management requires additional backend setup. Please use Django Admin for now.');
            this.closeProfessorModal();
        } catch (error) {
            console.error('Error saving professor:', error);
            alert('Failed to save professor');
        }
    }

    // Office CRUD
    async editOffice(id) {
        const office = this.offices.find(o => o.room_id === id);
        if (!office) return;

        document.getElementById('office-modal-title').textContent = 'Edit Office';
        document.getElementById('office-id').value = office.room_id;
        document.getElementById('office-number').value = office.room_number;
        document.getElementById('office-floor').value = office.floor_id;
        document.getElementById('office-location').value = office.building ? office.building.name : '';

        document.getElementById('office-modal').style.display = 'block';
    }

    async deleteOffice(id) {
        if (!confirm('Are you sure you want to delete this office?')) return;

        try {
            const token = localStorage.getItem('access_token') || sessionStorage.getItem('access_token');
            const response = await fetch(`http://localhost:8000/api/admin/offices/${id}/`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.ok) {
                alert('Office deleted successfully');
                await this.loadAllData();
                this.loadOfficesTable();
            } else {
                throw new Error('Delete failed');
            }
        } catch (error) {
            console.error('Error deleting office:', error);
            alert('Failed to delete office');
        }
    }

    async saveOffice() {
        alert('Office management requires additional backend setup. Please use Django Admin for now.');
        this.closeOfficeModal();
    }

    // Utility functions
    generateEmail(fullName) {
        const nameParts = fullName
            .replace(/Prof\.|Dr\.|Assoc\.|Asst\./gi, '')
            .trim()
            .toLowerCase()
            .split(' ')
            .filter(part => part.length > 0);

        if (nameParts.length >= 2) {
            return `${nameParts[0]}.${nameParts[nameParts.length - 1]}@final.edu.tr`;
        }
        return 'unknown@final.edu.tr';
    }

    // Modal functions
    closeProfessorModal() {
        document.getElementById('professor-modal').style.display = 'none';
        document.getElementById('professor-form').reset();
    }

    closeOfficeModal() {
        document.getElementById('office-modal').style.display = 'none';
        document.getElementById('office-form').reset();
    }
}

// Modal functions (global)
function openProfessorModal() {
    document.getElementById('professor-modal-title').textContent = 'Add Professor';
    document.getElementById('professor-id').value = '';
    
    // Load office select
    const officeSelect = document.getElementById('professor-office');
    officeSelect.innerHTML = '<option value="">Select Office</option>' + 
        admin.offices.map(o => `
            <option value="${o.room_id}">${o.room_number}</option>
        `).join('');
    
    document.getElementById('professor-modal').style.display = 'block';
}

function closeProfessorModal() {
    admin.closeProfessorModal();
}

function openOfficeModal() {
    document.getElementById('office-modal-title').textContent = 'Add Office';
    document.getElementById('office-id').value = '';
    document.getElementById('office-modal').style.display = 'block';
}

function closeOfficeModal() {
    admin.closeOfficeModal();
}

function openEquipmentModal() {
    alert('Equipment management coming soon!');
}

function logout() {
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    localStorage.removeItem('loginData');
    sessionStorage.removeItem('access_token');
    sessionStorage.removeItem('refresh_token');
    sessionStorage.removeItem('loginData');
    window.location.href = 'login.html';
}

// Initialize admin panel
let admin;
document.addEventListener('DOMContentLoaded', () => {
    admin = new AdminPanel();
    admin.init();
});
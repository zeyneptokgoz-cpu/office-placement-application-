class AcademicDirectoryApp {
    constructor() {
        this.currentFloor = 'floor1';
        this.currentView = 'grid';
        this.currentRequestType = null;
        this.allOffices = [];
        this.allFaculty = [];
        this.allAssignments = [];  // ← EKLENDI
        this.officesByFloor = {};
        this.isDataLoaded = false;
    }

    async init() {
        try {
            // Show loading indicator
            this.showLoading();
            
            // Load data from API
            await this.loadDataFromAPI();
            
            // Setup UI
            this.setupEventListeners();
            this.setupNavigation();
            AcademicDatabase.setLanguage('en');
            
            // Load initial view
            this.loadOffices();
            this.loadAllOffices();
            this.hideRequestForm();
            
            // Hide loading
            this.hideLoading();
            
            this.isDataLoaded = true;
        } catch (error) {
            console.error('Initialization error:', error);
            this.showError('Failed to load data. Please refresh the page.');
            this.hideLoading();
        }
    }

    async loadDataFromAPI() {
        try {
            // Fetch all data in parallel
            const [officesData, facultyData, assignmentsData] = await Promise.all([
                apiService.getOffices(),
                apiService.getFaculty(),
                apiService.getAssignments()  // ← EKLENDI
            ]);

            // Map offices
            this.allOffices = DataMapper.mapOffices(officesData);

            // Map faculty
            this.allFaculty = DataMapper.mapFacultyList(facultyData);

            // Store assignments
            this.allAssignments = assignmentsData;  // ← EKLENDI

            // Map assignments to offices - professor'ları ofislere ekle
            this.allAssignments.forEach(assignment => {
                const office = this.allOffices.find(o => o.id === assignment.office.room_number);
                const faculty = this.allFaculty.find(f => f.id === assignment.faculty.staff_id);

                if (office && faculty) {
                    // Ofise professor'u ekle
                    if (!office.professors) {
                        office.professors = [];
                    }
                    // Duplicate check
                    if (!office.professors.find(p => p.id === faculty.id)) {
                        office.professors.push({
                            id: faculty.id,
                            name: faculty.name,
                            department: faculty.department
                        });
                    }

                    // Faculty'e office bilgisini ekle
                    faculty.office = office.id;
                }
            });

            // Group offices by floor
            this.officesByFloor = DataMapper.groupOfficesByFloor(this.allOffices);

            console.log('Data loaded successfully:', {
                offices: this.allOffices.length,
                faculty: this.allFaculty.length,
                assignments: this.allAssignments.length  // ← EKLENDI
            });

        } catch (error) {
            console.error('Error loading data from API:', error);
            throw error;
        }
    }

    showLoading() {
        // Create loading overlay if it doesn't exist
        let loadingEl = document.getElementById('loading-overlay');
        if (!loadingEl) {
            loadingEl = document.createElement('div');
            loadingEl.id = 'loading-overlay';
            loadingEl.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.9);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 9999;
                font-size: 1.5rem;
                color: #2c5aa0;
            `;
            loadingEl.innerHTML = '<div>Loading data... ⏳</div>';
            document.body.appendChild(loadingEl);
        }
        loadingEl.style.display = 'flex';
    }

    hideLoading() {
        const loadingEl = document.getElementById('loading-overlay');
        if (loadingEl) {
            loadingEl.style.display = 'none';
        }
    }

    showError(message) {
        const errorEl = document.createElement('div');
        errorEl.style.cssText = `
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: #f44336;
            color: white;
            padding: 1rem 2rem;
            border-radius: 8px;
            z-index: 10000;
        `;
        errorEl.textContent = message;
        document.body.appendChild(errorEl);
        
        setTimeout(() => {
            errorEl.remove();
        }, 5000);
    }

    setupEventListeners() {
        // Floor tabs
        document.querySelectorAll('.tab').forEach(tab => {
            tab.addEventListener('click', (e) => {
                this.switchFloor(e.currentTarget.dataset.floor);
            });
        });

        // Search
        const searchInput = document.getElementById('search-input');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                this.handleSearch(e.target.value);
            });
        }

        // Language switcher
        document.querySelectorAll('.lang-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.switchLanguage(e.target.dataset.lang);
            });
        });

        // View options
        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.switchView(e.currentTarget.dataset.view);
            });
        });

        // Filters
        const floorFilter = document.getElementById('floor-filter');
        const deptFilter = document.getElementById('department-filter');
        
        if (floorFilter) {
            floorFilter.addEventListener('change', () => this.filterOffices());
        }
        
        if (deptFilter) {
            deptFilter.addEventListener('change', () => this.filterOffices());
        }

        // Request form
        const requestForm = document.getElementById('request-form');
        if (requestForm) {
            requestForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.handleRequestForm();
            });
        }
    }

    setupNavigation() {
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const target = link.getAttribute('href').substring(1);
                this.showSection(target);
                
                // Update active nav link
                document.querySelectorAll('.nav-link').forEach(l => {
                    l.classList.remove('active');
                });
                link.classList.add('active');
            });
        });
    }

    showSection(sectionId) {
        // Hide all sections
        document.querySelectorAll('.main-section').forEach(section => {
            section.classList.remove('active');
            section.classList.add('hidden');
        });
        
        // Show target section
        const targetSection = document.getElementById(sectionId);
        if (targetSection) {
            targetSection.classList.remove('hidden');
            targetSection.classList.add('active');
            
            // Load content if needed
            if (sectionId === 'office-list') {
                this.loadAllOffices();
            }
            
            // Hide request form when switching sections
            if (sectionId !== 'requests') {
                this.hideRequestForm();
            }
        }
    }

    switchFloor(floor) {
        this.currentFloor = floor;
        
        // Update tab styles
        document.querySelectorAll('.tab').forEach(tab => {
            tab.classList.remove('active');
            if (tab.dataset.floor === floor) {
                tab.classList.add('active');
            }
        });
        
        this.loadOffices();
    }

    loadOffices() {
        const grid = document.getElementById('office-grid');
        if (!grid) return;
        
        const offices = this.officesByFloor[this.currentFloor] || [];
        
        if (offices.length === 0) {
            grid.innerHTML = `<p class="no-results" data-i18n="no_offices">${AcademicDatabase.translate('no_offices')}</p>`;
            return;
        }
        
        grid.innerHTML = offices.map(office => this.createOfficeCard(office)).join('');
    }

    createOfficeCard(office) {
        const professorList = office.professors && office.professors.length > 0
            ? office.professors.map(p => p.name).join(', ')
            : 'No professors assigned';
        
        return `
            <div class="office-card" onclick="app.showOfficeDetail('${office.id}')">
                <div class="office-number">🏢 ${office.id}</div>
                <div class="office-info">
                    <div class="office-location">📍 ${office.location}</div>
                    <div class="office-professors">
                        ${office.professors && office.professors.length > 0
                            ? office.professors.map(p => `
                                <div class="professor-tag" onclick="event.stopPropagation(); app.showProfessorDetail(${p.id})">
                                    ${p.name}
                                </div>
                            `).join('')
                            : '<div class="no-professors">No professors assigned</div>'
                        }
                    </div>
                </div>
            </div>
        `;
    }

    loadAllOffices() {
        this.renderOfficeGrid();
        this.renderOfficeList();
        this.switchView(this.currentView);
    }

    renderOfficeGrid() {
        const grid = document.getElementById('all-offices-grid');
        if (!grid) return;
        
        let filtered = this.getFilteredOffices();
        
        if (filtered.length === 0) {
            grid.innerHTML = `<p class="no-results">${AcademicDatabase.translate('no_results')}</p>`;
            return;
        }
        
        grid.innerHTML = filtered.map(office => this.createOfficeCard(office)).join('');
    }

    renderOfficeList() {
        const list = document.getElementById('all-offices-list');
        if (!list) return;
        
        let filtered = this.getFilteredOffices();
        
        if (filtered.length === 0) {
            list.innerHTML = `<p class="no-results">${AcademicDatabase.translate('no_results')}</p>`;
            return;
        }
        
        list.innerHTML = filtered.map(office => `
            <div class="office-list-item" onclick="app.showOfficeDetail('${office.id}')">
                <div class="list-office-number">🏢 ${office.id}</div>
                <div class="list-office-info">
                    <div class="list-office-floor">${office.floor}</div>
                    <div class="list-office-location">📍 ${office.location}</div>
                </div>
                <div class="list-professors">
                    ${office.professors && office.professors.length > 0
                        ? office.professors.map(p => `
                            <span class="professor-tag" onclick="event.stopPropagation(); app.showProfessorDetail(${p.id})">${p.name}</span>
                        `).join('')
                        : '<span class="no-professors">No professors assigned</span>'
                    }
                </div>
            </div>
        `).join('');
    }

    getFilteredOffices() {
        const floorFilter = document.getElementById('floor-filter')?.value || '';
        const deptFilter = document.getElementById('department-filter')?.value || '';
        
        return this.allOffices.filter(office => {
            const floorMatch = !floorFilter || office.floor === floorFilter;
            const deptMatch = !deptFilter || (office.professors && office.professors.some(p => p.department === deptFilter));
            return floorMatch && deptMatch;
        });
    }

    filterOffices() {
        this.renderOfficeGrid();
        this.renderOfficeList();
    }

    switchView(view) {
        this.currentView = view;
        
        // Update button states
        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.classList.remove('active');
            if (btn.dataset.view === view) {
                btn.classList.add('active');
            }
        });
        
        // Show/hide views
        const grid = document.getElementById('all-offices-grid');
        const list = document.getElementById('all-offices-list');
        
        if (view === 'grid') {
            if (grid) grid.style.display = 'grid';
            if (list) list.style.display = 'none';
        } else {
            if (grid) grid.style.display = 'none';
            if (list) list.style.display = 'block';
        }
    }

    handleSearch(query) {
        if (!query.trim()) {
            this.loadOffices();
            return;
        }
        
        const results = DataMapper.performSearch(query, this.allOffices, this.allFaculty);
        const grid = document.getElementById('office-grid');
        
        if (!grid) return;
        
        if (results.length === 0) {
            grid.innerHTML = `<p class="no-results" data-i18n="no_results">${AcademicDatabase.translate('no_results')}</p>`;
            return;
        }
        
        grid.innerHTML = results.map(result => {
            if (result.type === 'office') {
                return this.createOfficeCard(result.data);
            } else {
                // Professor result - show their office card
                const office = this.allOffices.find(o => 
                    o.professors && o.professors.some(p => p.id === result.data.id)
                );
                if (office) {
                    return this.createOfficeCard(office);
                }
                return '';
            }
        }).join('');
    }

    showProfessorDetail(professorId) {
        const professor = this.allFaculty.find(p => p.id === professorId);
        if (!professor) {
            console.error('Professor not found:', professorId);
            return;
        }
        
        // Find office for this professor
        const office = this.allOffices.find(o => 
            o.professors && o.professors.some(p => p.id === professorId)
        );
        
        const detail = DataMapper.createProfessorDetail(professor, office);
        
        // Populate detail section
        document.getElementById('prof-name').textContent = detail.name;
        document.getElementById('prof-department').textContent = detail.department;
        document.getElementById('prof-email').textContent = detail.email;
        document.getElementById('prof-phone').textContent = detail.phone;
        document.getElementById('prof-office').textContent = detail.office;
        
        // Populate schedule
        this.populateSchedule(detail.schedule);
        
        // Show detail section
        this.showSection('professor-detail');
    }

    populateSchedule(schedule) {
        const tbody = document.getElementById('schedule-body');
        if (!tbody) return;
        
        const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];
        const allTimes = new Set();
        
        // Collect all unique time slots
        days.forEach(day => {
            if (schedule[day]) {
                schedule[day].forEach(item => {
                    allTimes.add(item.time);
                });
            }
        });
        
        const timeSlots = Array.from(allTimes).sort();
        
        tbody.innerHTML = timeSlots.map(time => `
            <tr>
                <td class="time-cell">${time}</td>
                ${days.map(day => {
                    const daySchedule = schedule[day] || [];
                    const item = daySchedule.find(s => s.time === time);
                    if (item) {
                        const className = item.type === 'lecture' ? 'lecture' : 'office-hours';
                        return `<td class="${className}">${item.title}</td>`;
                    }
                    return '<td></td>';
                }).join('')}
            </tr>
        `).join('');
    }

    showOfficeDetail(officeId) {
        const office = this.allOffices.find(o => o.id === officeId);
        if (!office) {
            console.error('Office not found:', officeId);
            return;
        }
        
        // Populate office detail section
        document.getElementById('office-number').textContent = `Office ${office.id}`;
        document.getElementById('office-location').textContent = `${office.floor} - ${office.location}`;
        
        // Populate professors
        const profContainer = document.getElementById('office-professors');
        if (profContainer) {
            profContainer.innerHTML = office.professors && office.professors.length > 0 
                ? office.professors.map(p => `
                    <div class="professor-card" onclick="app.showProfessorDetail(${p.id})">
                        <div class="professor-name">${p.name}</div>
                        <div class="professor-dept">${p.department}</div>
                    </div>
                `).join('')
                : '<p>No professors assigned to this office.</p>';
        }
        
        // Populate equipment
        const equipContainer = document.getElementById('office-equipment');
        if (equipContainer) {
            equipContainer.innerHTML = office.sharedEquipment.map(eq => `
                <div class="equipment-item">${eq}</div>
            `).join('');
        }
        
        // Show detail section
        this.showSection('office-detail');
    }

    showHomePage() {
        this.showSection('home');
        document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
        document.querySelector('.nav-link[href="#home"]')?.classList.add('active');
    }

    switchLanguage(lang) {
        AcademicDatabase.setLanguage(lang);
        
        // Update button states
        document.querySelectorAll('.lang-btn').forEach(btn => {
            btn.classList.remove('active');
            if (btn.dataset.lang === lang) {
                btn.classList.add('active');
            }
        });
        
        // Reload current view
        this.loadOffices();
        this.loadAllOffices();
    }

    // Request form methods
    showRequestForm(type) {
        this.currentRequestType = type;
        const container = document.getElementById('request-form-container');
        const form = document.getElementById('request-form');
        const title = document.getElementById('request-form-title');
        
        if (!container || !form || !title) return;
        
        // Set title
        const titles = {
            appointment: AcademicDatabase.translate('request_appointment'),
            equipment: AcademicDatabase.translate('request_equipment'),
            maintenance: AcademicDatabase.translate('request_maintenance'),
            other: AcademicDatabase.translate('request_other')
        };
        
        title.textContent = titles[type] || 'Request Form';
        
        // Generate form fields based on type
        form.innerHTML = this.generateRequestFormHTML(type);
        
        // Show form
        document.querySelector('.request-options').style.display = 'none';
        container.style.display = 'block';
    }

    generateRequestFormHTML(type) {
        const common = `
            <div class="form-group">
                <label>${AcademicDatabase.translate('request_details')}</label>
                <textarea name="details" required rows="4"></textarea>
            </div>
        `;
        
        if (type === 'appointment') {
            return `
                <div class="form-group">
                    <label>${AcademicDatabase.translate('select_professor')}</label>
                    <select name="professor" required>
                        <option value="">Select...</option>
                        ${this.allFaculty.map(p => `<option value="${p.id}">${p.name}</option>`).join('')}
                    </select>
                </div>
                <div class="form-group">
                    <label>${AcademicDatabase.translate('request_date')}</label>
                    <input type="date" name="date" required>
                </div>
                <div class="form-group">
                    <label>${AcademicDatabase.translate('request_time')}</label>
                    <input type="time" name="time" required>
                </div>
                ${common}
                <button type="submit" class="submit-btn">${AcademicDatabase.translate('submit_request_btn')}</button>
            `;
        } else if (type === 'equipment') {
            return `
                <div class="form-group">
                    <label>${AcademicDatabase.translate('select_office')}</label>
                    <select name="office" required>
                        <option value="">Select...</option>
                        ${this.allOffices.map(o => `<option value="${o.id}">${o.id} - ${o.location}</option>`).join('')}
                    </select>
                </div>
                <div class="form-group">
                    <label>${AcademicDatabase.translate('equipment_name')}</label>
                    <input type="text" name="equipment" required>
                </div>
                ${common}
                <button type="submit" class="submit-btn">${AcademicDatabase.translate('submit_request_btn')}</button>
            `;
        } else {
            return `
                ${common}
                <button type="submit" class="submit-btn">${AcademicDatabase.translate('submit_request_btn')}</button>
            `;
        }
    }

    hideRequestForm() {
        const container = document.getElementById('request-form-container');
        const options = document.querySelector('.request-options');
        
        if (container) container.style.display = 'none';
        if (options) options.style.display = 'grid';
    }

    handleRequestForm() {
        // For now, just show success message
        // You can extend this to actually send data to backend
        alert(AcademicDatabase.translate('request_success'));
        this.hideRequestForm();
    }
}

// Global app instance
let app;

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    app = new AcademicDirectoryApp();
    app.init();
});
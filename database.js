const AcademicDatabase = {
    currentLanguage: 'en',

    translations: {
        en: {
            // HOME PAGE
            home: "Home",
            main_title: "Academic Staff Directory",
            main_subtitle: "Quick access to faculty and office information",
            search_placeholder: "Search by name, department or office number...",
            
            // NAVIGATION
            office_list: "Office List",
            requests: "Requests",
            contact: "Contact",
            admin_panel: "Admin Panel",
            
            // PROFESSOR DETAIL
            weekly_schedule: "Weekly Schedule",
            office_professors: "Professors in this Office",
            shared_equipment: "Shared Equipment",
            
            // SCHEDULE TABLE
            time: "Time",
            monday: "Monday",
            tuesday: "Tuesday",
            wednesday: "Wednesday",
            thursday: "Thursday",
            friday: "Friday",
            
            // COMMON
            professor: "Professor",
            office: "Office",
            no_results: "No results found for your search.",
            no_offices: "No offices found on this floor.",
            
            // FLOORS
            floor_1: "1st Floor",
            floor_2: "2nd Floor",
            floor_3: "3rd Floor",
            floor_4: "4th Floor",
            
            // OFFICE LIST
            all_offices: "All Offices",
            grid_view: "Grid View",
            list_view: "List View",
            all_floors: "All Floors",
            all_departments: "All Departments",
            
            // CONTACT
            contact_info: "Contact Information",
            general_inquiries: "General Inquiries",
            email: "Email",
            campus_address: "Campus Address",
            office_management: "Office Management",
            for_academic_inquiries: "For general academic inquiries",
            working_hours: "Monday - Friday, 9:00 - 17:00",
            for_office_changes: "For office assignments and changes",
            quick_links: "Quick Links",
            search_directory: "Search Directory",
            admin_access: "Admin Access",
            university_website: "University Website",
            
            // BACK BUTTON
            back_home: "Back to Home",
            back: "Back",

            // DEPARTMENTS
            dept_computer: "Computer Engineering",
            dept_software: "Software Engineering",
            dept_mechanical: "Mechanical Engineering",
            dept_civil: "Civil Engineering",
            dept_electrical: "Electrical-Electronics Eng.",
            dept_math: "Mathematics",
            dept_physics: "Physics",
            dept_architecture: "Architecture",
            dept_literature: "Literature",
            dept_admin: "Administration",
            
            // REQUESTS SECTION
            submit_request: "Submit a Request",
            request_subtitle: "Request appointments, equipment, or other needs",
            request_appointment: "Appointment Request",
            request_appointment_desc: "Request a meeting with a professor",
            request_equipment: "Equipment Request",
            request_equipment_desc: "Request equipment from a shared office",
            request_maintenance: "Maintenance Request",
            request_maintenance_desc: "Report issues with office equipment",
            request_other: "Other Request",
            request_other_desc: "Submit other types of requests",
            
            // REQUEST FORM
            select_professor: "Select Professor",
            select_office: "Select Office",
            request_date: "Preferred Date",
            request_time: "Preferred Time",
            request_reason: "Reason for Request",
            equipment_name: "Equipment Name",
            issue_description: "Issue Description",
            request_details: "Request Details",
            submit_request_btn: "Submit Request",
            request_success: "Request submitted successfully!"
        },
        tr: {
            // HOME PAGE
            home: "Ana Sayfa",
            main_title: "Akademik Personel Rehberi",
            main_subtitle: "Hoca ve ofis bilgilerine hızlıca ulaşın",
            search_placeholder: "İsim, bölüm veya ofis numarası ile arayın...",
            
            // NAVIGATION
            office_list: "Ofis Listesi",
            requests: "Talepler",
            contact: "İletişim",
            admin_panel: "Yönetici Paneli",
            
            // PROFESSOR DETAIL
            weekly_schedule: "Haftalık Program",
            office_professors: "Bu Ofisteki Hocalar",
            shared_equipment: "Ortak Kullanılan Ekipmanlar",
            
            // SCHEDULE TABLE
            time: "Saat",
            monday: "Pazartesi",
            tuesday: "Salı",
            wednesday: "Çarşamba",
            thursday: "Perşembe",
            friday: "Cuma",
            
            // COMMON
            professor: "Hoca",
            office: "Ofis",
            no_results: "Aramanızla eşleşen sonuç bulunamadı.",
            no_offices: "Bu katta ofis bulunmamaktadır.",
            
            // FLOORS
            floor_1: "1. Kat",
            floor_2: "2. Kat",
            floor_3: "3. Kat",
            floor_4: "4. Kat",
            
            // OFFICE LIST
            all_offices: "Tüm Ofisler",
            grid_view: "Grid Görünümü",
            list_view: "Liste Görünümü",
            all_floors: "Tüm Katlar",
            all_departments: "Tüm Bölümler",
            
            // CONTACT
            contact_info: "İletişim Bilgileri",
            general_inquiries: "Genel Bilgiler",
            email: "E-posta",
            campus_address: "Kampüs Adresi",
            office_management: "Ofis Yönetimi",
            for_academic_inquiries: "Genel akademik sorgular için",
            working_hours: "Pazartesi - Cuma, 09:00 - 17:00",
            for_office_changes: "Ofis atamaları ve değişiklikleri için",
            quick_links: "Hızlı Bağlantılar",
            search_directory: "Dizinde Ara",
            admin_access: "Yönetici Erişimi",
            university_website: "Üniversite Web Sitesi",
            
            // BACK BUTTON
            back_home: "Ana Sayfaya Dön",
            back: "Geri",

            // DEPARTMENTS
            dept_computer: "Bilgisayar Mühendisliği",
            dept_software: "Yazılım Mühendisliği",
            dept_mechanical: "Makine Mühendisliği",
            dept_civil: "İnşaat Mühendisliği",
            dept_electrical: "Elektrik-Elektronik Müh.",
            dept_math: "Matematik",
            dept_physics: "Fizik",
            dept_architecture: "Mimarlık",
            dept_literature: "Edebiyat",
            dept_admin: "İdari",
            
            // REQUESTS SECTION
            submit_request: "Talep Gönder",
            request_subtitle: "Randevu, ekipman veya diğer ihtiyaçlar için talep oluşturun",
            request_appointment: "Randevu Talebi",
            request_appointment_desc: "Bir hoca ile görüşme talebi oluşturun",
            request_equipment: "Ekipman Talebi",
            request_equipment_desc: "Ortak ofisten ekipman talebi",
            request_maintenance: "Bakım Talebi",
            request_maintenance_desc: "Ofis ekipmanı sorunlarını bildirin",
            request_other: "Diğer Talep",
            request_other_desc: "Diğer talep türlerini gönderin",
            
            // REQUEST FORM
            select_professor: "Hoca Seçin",
            select_office: "Ofis Seçin",
            request_date: "Tercih Edilen Tarih",
            request_time: "Tercih Edilen Saat",
            request_reason: "Talep Nedeni",
            equipment_name: "Ekipman Adı",
            issue_description: "Sorun Açıklaması",
            request_details: "Talep Detayları",
            submit_request_btn: "Talep Gönder",
            request_success: "Talep başarıyla gönderildi!"
        }
    },

    setLanguage: function(lang) {
        this.currentLanguage = lang;
        this.updateUITexts();
        localStorage.setItem('preferredLanguage', lang);
    },

    t: function(key) {
        return this.translations[this.currentLanguage][key] || key;
    },

    updateUITexts: function() {
        // 1. Tüm data-i18n özelliği olan elementleri güncelle
        document.querySelectorAll('[data-i18n]').forEach(element => {
            const key = element.getAttribute('data-i18n');
            if (this.translations[this.currentLanguage][key]) {
                element.textContent = this.t(key);
            }
        });

        // 2. Placeholder'ları güncelle
        document.querySelectorAll('[data-i18n-placeholder]').forEach(element => {
            const key = element.getAttribute('data-i18n-placeholder');
            element.placeholder = this.t(key);
        });

        // 3. Floor tab'larını güncelle
        document.querySelectorAll('[data-floor]').forEach(tab => {
            const floor = tab.dataset.floor;
            if (this.translations[this.currentLanguage][`floor_${floor.slice(-1)}`]) {
                tab.textContent = this.t(`floor_${floor.slice(-1)}`);
            }
        });

        // 4. Option'ları güncelle
        document.querySelectorAll('option[data-i18n]').forEach(option => {
            const key = option.getAttribute('data-i18n');
            if (this.translations[this.currentLanguage][key]) {
                option.textContent = this.t(key);
            }
        });

        // 5. Select'lerin placeholder option'larını güncelle
        document.querySelectorAll('select option[value=""]').forEach(option => {
            if (option.hasAttribute('data-i18n')) {
                const key = option.getAttribute('data-i18n');
                option.textContent = this.t(key);
            }
        });

        // 6. Button value'larını güncelle
        document.querySelectorAll('button[data-i18n]').forEach(button => {
            const key = button.getAttribute('data-i18n');
            if (this.translations[this.currentLanguage][key]) {
                button.textContent = this.t(key);
            }
        });

        // 7. Input value'larını güncelle
        document.querySelectorAll('input[data-i18n-value]').forEach(input => {
            const key = input.getAttribute('data-i18n-value');
            if (this.translations[this.currentLanguage][key]) {
                input.value = this.t(key);
            }
        });
    },

    getOffices: function(floor = 'floor1') {
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve(this.officeData[floor] || []);
            }, 100);
        });
    },

    getAllOffices: function() {
        return new Promise((resolve) => {
            setTimeout(() => {
                const allOffices = [];
                for (const floor in this.officeData) {
                    allOffices.push(...this.officeData[floor]);
                }
                resolve(allOffices);
            }, 100);
        });
    },

    getProfessor: function(professorId) {
        return new Promise((resolve) => {
            setTimeout(() => {
                const professor = this.findProfessorById(professorId);
                resolve(professor);
            }, 100);
        });
    },

    getOfficeDetail: function(officeId) {
        return new Promise((resolve) => {
            setTimeout(() => {
                const office = this.findOfficeById(officeId);
                resolve(office);
            }, 100);
        });
    },

    search: function(query) {
        return new Promise((resolve) => {
            setTimeout(() => {
                const results = this.performSearch(query);
                resolve(results);
            }, 150);
        });
    },

    officeData: {
        floor1: [
            {
                id: "101",
                floor: "1st Floor",
                location: "North Corridor",
                professors: [
                    { id: 1, name: "Prof. Dr. Ahmet Demir", department: "Computer Engineering" },
                    { id: 2, name: "Assoc. Prof. Dr. Zeynep Kaya", department: "Software Engineering" }
                ],
                sharedEquipment: ["🖨️ 3D Printer", "💻 2x Desktop Computers", "📞 Conference System"]
            },
            {
                id: "102",
                floor: "1st Floor", 
                location: "South Corridor",
                professors: [
                    { id: 3, name: "Dr. Öğr. Üyesi Mehmet Yıldız", department: "Electrical-Electronics Eng." }
                ],
                sharedEquipment: ["💻 1x Desktop Computer", "📞 Telephone", "🖨️ Laser Printer"]
            },
            {
                id: "103",
                floor: "1st Floor", 
                location: "East Corridor",
                professors: [
                    { id: 7, name: "Prof. Dr. Fatma Arslan", department: "Mathematics" }
                ],
                sharedEquipment: ["💻 1x Computer", "📱 Tablet", "✏️ Whiteboard"]
            }
        ],
        floor2: [
            {
                id: "201",
                floor: "2nd Floor",
                location: "East Corridor", 
                professors: [
                    { id: 4, name: "Prof. Dr. Ayşe Yılmaz", department: "Mechanical Engineering" }
                ],
                sharedEquipment: ["💻 2x Computers", "📊 Projector", "🖨️ Scanner"]
            },
            {
                id: "202",
                floor: "2nd Floor",
                location: "West Corridor", 
                professors: [
                    { id: 5, name: "Prof. Dr. Mustafa Öztürk", department: "Civil Engineering" }
                ],
                sharedEquipment: ["💻 1x Computer", "📱 Tablet", "🎧 Headphones"]
            },
            {
                id: "203",
                floor: "2nd Floor",
                location: "Main Hall", 
                professors: [
                    { id: 8, name: "Assoc. Prof. Dr. Ali Şahin", department: "Physics" }
                ],
                sharedEquipment: ["💻 2x Computers", "🔬 Lab Equipment", "📚 Books"]
            }
        ],
        floor3: [
            {
                id: "301",
                floor: "3rd Floor",
                location: "Main Corridor", 
                professors: [
                    { id: 6, name: "Prof. Dr. Elif Şahin", department: "Architecture" }
                ],
                sharedEquipment: ["💻 2x iMac", "✏️ Drawing Tablets", "📐 Architecture Tools"]
            },
            {
                id: "302",
                floor: "3rd Floor",
                location: "Library Wing", 
                professors: [
                    { id: 9, name: "Prof. Dr. Can Yılmaz", department: "Literature" }
                ],
                sharedEquipment: ["💻 1x Computer", "📖 Book Scanner", "🖨️ Color Printer"]
            }
        ],
        floor4: [
            {
                id: "401",
                floor: "4th Floor",
                location: "Executive Wing", 
                professors: [
                    { id: 10, name: "Prof. Dr. Hasan Yıldırım", department: "Administration" }
                ],
                sharedEquipment: ["💻 3x Computers", "📞 Phone System", "🖨️ Multifunction Printer"]
            }
        ]
    },

    professorDetails: {
        1: {
            id: 1,
            name: "Prof. Dr. Ahmet Demir",
            department: "Computer Engineering",
            email: "ahmet.demir@final.edu.tr",
            phone: "+90 (312) 123 45 67",
            extension: "101",
            office: "101",
            schedule: {
                monday: [
                    { time: "09:00-11:00", type: "lecture", title: "Algorithms" },
                    { time: "14:00-16:00", type: "office", title: "Office Hours" }
                ],
                tuesday: [
                    { time: "10:00-12:00", type: "lecture", title: "Data Structures" }
                ],
                wednesday: [
                    { time: "13:00-15:00", type: "office", title: "Office Hours" }
                ],
                thursday: [],
                friday: [
                    { time: "09:00-12:00", type: "lecture", title: "Artificial Intelligence" }
                ]
            },
            personalEquipment: ["💻 MacBook Pro", "📊 Graphics Tablet"]
        },
        2: {
            id: 2,
            name: "Assoc. Prof. Dr. Zeynep Kaya",
            department: "Software Engineering",
            email: "zeynep.kaya@final.edu.tr",
            phone: "+90 (312) 123 45 68",
            extension: "102",
            office: "101",
            schedule: {
                monday: [
                    { time: "10:00-12:00", type: "lecture", title: "Web Programming" }
                ],
                tuesday: [
                    { time: "14:00-16:00", type: "office", title: "Office Hours" }
                ],
                wednesday: [
                    { time: "09:00-11:00", type: "lecture", title: "Mobile Applications" }
                ],
                thursday: [
                    { time: "13:00-15:00", type: "office", title: "Office Hours" }
                ],
                friday: []
            },
            personalEquipment: ["💻 Dell XPS", "📱 Test Devices"]
        },
        3: {
            id: 3,
            name: "Dr. Öğr. Üyesi Mehmet Yıldız",
            department: "Electrical-Electronics Eng.",
            email: "mehmet.yildiz@final.edu.tr",
            phone: "+90 (312) 123 45 69",
            extension: "103",
            office: "102",
            schedule: {
                monday: [
                    { time: "13:00-15:00", type: "lecture", title: "Circuit Theory" }
                ],
                tuesday: [
                    { time: "09:00-11:00", type: "office", title: "Office Hours" }
                ],
                wednesday: [
                    { time: "10:00-12:00", type: "lecture", title: "Signal Processing" }
                ],
                thursday: [
                    { time: "14:00-16:00", type: "lecture", title: "Electronics" }
                ],
                friday: [
                    { time: "11:00-13:00", type: "office", title: "Office Hours" }
                ]
            },
            personalEquipment: ["💻 ThinkPad", "🔌 Measurement Tools"]
        }
    },

    findProfessorById: function(id) {
        return this.professorDetails[id] || null;
    },

    findOfficeById: function(officeId) {
        for (const floor in this.officeData) {
            const office = this.officeData[floor].find(office => office.id === officeId);
            if (office) return office;
        }
        return null;
    },

    findFloorByOfficeId: function(officeId) {
        for (const floor in this.officeData) {
            const office = this.officeData[floor].find(o => o.id === officeId);
            if (office) return floor;
        }
        return 'floor1';
    },

    performSearch: function(query) {
        if (!query) return [];
        
        const results = [];
        const lowerQuery = query.toLowerCase();
        
        for (const floor in this.officeData) {
            this.officeData[floor].forEach(office => {
                if (office.id.toLowerCase().includes(lowerQuery)) {
                    results.push({ type: 'office', data: office });
                }
                
                office.professors.forEach(professor => {
                    if (professor.name.toLowerCase().includes(lowerQuery) || 
                        professor.department.toLowerCase().includes(lowerQuery)) {
                        results.push({ type: 'professor', data: professor });
                    }
                });
            });
        }
        
        return results;
    },

    getAllProfessors: function() {
        const professors = [];
        for (const id in this.professorDetails) {
            professors.push(this.professorDetails[id]);
        }
        return professors;
    },

    getAllOfficesSimple: function() {
        const offices = [];
        for (const floor in this.officeData) {
            offices.push(...this.officeData[floor]);
        }
        return offices;
    },

    // Translate helper function
    translate: function(key) {
        const lang = this.currentLanguage || 'en';
        return this.translations[lang][key] || key;
    },

    // Initialize language
    initLanguage: function() {
        const savedLanguage = localStorage.getItem('preferredLanguage') || 'en';
        this.currentLanguage = savedLanguage;
    }
};

// Sayfa yüklendiğinde dili başlat
if (typeof document !== 'undefined') {
    document.addEventListener('DOMContentLoaded', function() {
        AcademicDatabase.initLanguage();
    });
}
// Data Mapper - Converts backend data to frontend format
class DataMapper {
    
    // Map backend office data to frontend format
    static mapOffice(backendOffice) {
        // Backend'den gelen format:
        // {
        //   room_id: 1,
        //   room_number: "101",
        //   capacity: 2,
        //   floor_id: 1,
        //   building: { building_id: 1, name: "Main Building", code: "MB" },
        //   department: { department_id: 1, name: "Computer Engineering" },
        //   professors: [...]  // Bu assignment'lardan doldurulacak
        // }
        
        // Tüm floor'ları destekle
        const floorNames = {
            1: "1st Floor",
            2: "2nd Floor", 
            3: "3rd Floor",
            4: "4th Floor",
            5: "5th Floor",
            6: "6th Floor",
            7: "7th Floor",
            8: "8th Floor",
            9: "9th Floor"
        };

        return {
            id: backendOffice.room_number,
            floor: floorNames[backendOffice.floor_id] || `Floor ${backendOffice.floor_id}`,
            location: backendOffice.building ? backendOffice.building.name : "Unknown",
            professors: backendOffice.professors || [],
            sharedEquipment: this.generateDefaultEquipment(backendOffice.capacity),
            // Keep original data for reference
            _raw: backendOffice
        };
    }

    // Map backend faculty data to frontend format
    static mapFaculty(backendFaculty) {
        // Backend'den gelen format:
        // {
        //   staff_id: 1,
        //   full_name: "Prof. Dr. Ahmet Demir",
        //   title_id: 1,
        //   department: { department_id: 1, name: "Computer Engineering" }
        // }

        return {
            id: backendFaculty.staff_id,
            name: backendFaculty.full_name,
            department: backendFaculty.department ? backendFaculty.department.name : "Unknown Department",
            email: this.generateEmail(backendFaculty.full_name),
            phone: "+90 (312) 123 45 67", // Default - Can be extended
            extension: String(100 + backendFaculty.staff_id),
            office: "N/A", // Will be filled from assignments
            // Keep original data
            _raw: backendFaculty
        };
    }

    // Map multiple offices
    static mapOffices(backendOffices) {
        return backendOffices.map(office => this.mapOffice(office));
    }

    // Map multiple faculty
    static mapFacultyList(backendFaculty) {
        return backendFaculty.map(faculty => this.mapFaculty(faculty));
    }

    // Group offices by floor for the main page
    static groupOfficesByFloor(offices) {
        const grouped = {
            floor1: [],
            floor2: [],
            floor3: [],
            floor4: [],
            floor5: []  // Other floors (5, 6, 7, 8, 9)
        };

        offices.forEach(office => {
            const floorId = office._raw.floor_id;
            
            if (floorId >= 1 && floorId <= 4) {
                // Standard floors
                const key = `floor${floorId}`;
                grouped[key].push(office);
            } else {
                // Other floors (5, 6, 7, 8, 9, etc.)
                grouped.floor5.push(office);
            }
        });

        return grouped;
    }

    // Generate default equipment based on capacity
    static generateDefaultEquipment(capacity) {
        const equipment = ["💻 Computer", "🖨️ Printer"];
        if (capacity && capacity >= 2) {
            equipment.push("📊 Projector");
        }
        if (capacity && capacity >= 3) {
            equipment.push("🔌 Extension Cables");
        }
        return equipment;
    }

    // Generate email from full name
    static generateEmail(fullName) {
        // "Prof. Dr. Ahmet Demir" -> "ahmet.demir@final.edu.tr"
        if (!fullName) return 'unknown@final.edu.tr';
        
        const nameParts = fullName
            .replace(/Prof\.|Dr\.|Assoc\.|Asst\.|Assist\.|Öğr\.|Üyesi|Sen\.|Lecturer|Instructor/gi, '')
            .trim()
            .toLowerCase()
            .split(' ')
            .filter(part => part.length > 0);

        if (nameParts.length >= 2) {
            const firstName = this.turkishToEnglish(nameParts[0]);
            const lastName = this.turkishToEnglish(nameParts[nameParts.length - 1]);
            return `${firstName}.${lastName}@final.edu.tr`;
        } else if (nameParts.length === 1) {
            const name = this.turkishToEnglish(nameParts[0]);
            return `${name}@final.edu.tr`;
        }

        return 'unknown@final.edu.tr';
    }

    // Convert Turkish characters to English
    static turkishToEnglish(text) {
        if (!text) return '';
        
        const turkishMap = {
            'ç': 'c', 'ğ': 'g', 'ı': 'i', 'ö': 'o', 'ş': 's', 'ü': 'u',
            'Ç': 'C', 'Ğ': 'G', 'İ': 'I', 'Ö': 'O', 'Ş': 'S', 'Ü': 'U'
        };

        return text.split('').map(char => turkishMap[char] || char).join('');
    }

    // Create professor detail object (for detail page)
    static createProfessorDetail(faculty, office = null) {
        return {
            id: faculty.id,
            name: faculty.name,
            department: faculty.department,
            email: faculty.email,
            phone: faculty.phone,
            extension: faculty.extension,
            office: office ? office.id : faculty.office,
            schedule: this.generateDefaultSchedule(), // Mock schedule - can be extended
            personalEquipment: ["💻 Laptop", "📱 Tablet"]
        };
    }

    // Generate default schedule (can be replaced with real data later)
    static generateDefaultSchedule() {
        return {
            monday: [
                { time: "09:00-11:00", type: "lecture", title: "Lecture" },
                { time: "14:00-16:00", type: "office", title: "Office Hours" }
            ],
            tuesday: [
                { time: "10:00-12:00", type: "lecture", title: "Lecture" }
            ],
            wednesday: [
                { time: "13:00-15:00", type: "office", title: "Office Hours" }
            ],
            thursday: [],
            friday: [
                { time: "09:00-12:00", type: "lecture", title: "Lecture" }
            ]
        };
    }

    // Search function - searches through mapped data
    static performSearch(query, offices, faculty) {
        if (!query) return [];
        
        const results = [];
        const lowerQuery = query.toLowerCase();
        
        // Search in offices
        offices.forEach(office => {
            if (office.id && office.id.toLowerCase().includes(lowerQuery)) {
                results.push({ type: 'office', data: office });
            }
        });
        
        // Search in faculty
        faculty.forEach(professor => {
            if (professor.name && professor.name.toLowerCase().includes(lowerQuery)) {
                results.push({ type: 'professor', data: professor });
            } else if (professor.department && professor.department.toLowerCase().includes(lowerQuery)) {
                results.push({ type: 'professor', data: professor });
            }
        });
        
        return results;
    }
}
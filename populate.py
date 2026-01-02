import os
import random
import unicodedata
import django
from django.utils.text import slugify

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'office_management.settings')
django.setup()

from django.contrib.auth.models import User, Group
from api.models import Building, Department, Faculty, Office

DEFAULT_PASS = "Final1234!"

def tr_to_ascii(s: str) -> str:
    if not s: return ""
    s = s.strip()
    replace_map = str.maketrans({
        "ç": "c", "Ç": "c", "ğ": "g", "Ğ": "g", "ı": "i", "İ": "i",
        "ö": "o", "Ö": "o", "ş": "s", "Ş": "s", "ü": "u", "Ü": "u",
    })
    s = s.translate(replace_map)
    s = unicodedata.normalize("NFKD", s)
    return "".join(ch for ch in s if not unicodedata.combining(ch))

def slug_username(full_name: str) -> str:
    full_name = tr_to_ascii(full_name)
    parts = [p for p in full_name.replace(",", " ").split() if p]
    if not parts: return ""
    first = "".join(ch for ch in parts[0].lower() if ch.isalnum())
    last = "".join(ch for ch in parts[-1].lower() if ch.isalnum())
    if not first or not last: return "user"
    return f"{first}.{last}"

def unique_username(base: str) -> str:
    base = base.strip().lower()
    u = base
    i = 1
    while User.objects.filter(username=u).exists():
        return u 
    return u

def create_full_data():
    print("🚀 Starting full data population...")

    BUILDINGS_DATA = [
        {"id": 1, "name": "(No Building)", "code": "None"},
        {"id": 2, "name": "Arts & Sciences Building", "code": "AS"},
        {"id": 3, "name": "Faculty of Arts", "code": "Arts"},
        {"id": 4, "name": "Faculty of Economics", "code": "Econ"},
        {"id": 5, "name": "Faculty of Education", "code": "Edu"},
        {"id": 6, "name": "Faculty of Engineering", "code": "Eng"},
        {"id": 7, "name": "Faculty of Law", "code": "Law"},
        {"id": 8, "name": "Medicosocial Center", "code": "Medico"},
        {"id": 9, "name": "Rectorate", "code": "Rector"}
    ]

    DEPARTMENTS_DATA = [
        {"id": 1, "name": "(Unspecified)"}, {"id": 2, "name": "Dean's Office (Faculty of Architecture and Fine Arts) (Including Vice Dean)"}, {"id": 3, "name": "Dean's Office (Faculty of Health Sciences)"}, {"id": 4, "name": "Dean's Office - Faculty of Arts and Sciences"}, {"id": 5, "name": "Dean's Office - Faculty of Economics and Administrative Sciences"}, {"id": 6, "name": "Dean's Office - Faculty of Educational Sciences"}, {"id": 7, "name": "Dean's Office - Faculty of Engineering"}, {"id": 8, "name": "Dean's Office - Faculty of Law"}, {"id": 9, "name": "Faculty of Architecture"}, {"id": 10, "name": "Faculty of Arts and Sciences"}, {"id": 11, "name": "Faculty of Economics and Administrative Sciences"}, {"id": 12, "name": "Faculty of Educational Sciences"}, {"id": 13, "name": "Faculty of Educational Sciences & School of Foreign Languages"}, {"id": 14, "name": "Faculty of Educational Sciences & Vice Dean"}, {"id": 15, "name": "Faculty of Engineering"}, {"id": 16, "name": "Faculty of Engineering & Faculty of Architecture"}, {"id": 17, "name": "Faculty of Law & Faculty of Architecture"}, {"id": 18, "name": "Health Center & Vocational School Director"}, {"id": 19, "name": "Institute of Graduate Studies Director (Including Vice Director)"}, {"id": 20, "name": "Kitchen"}, {"id": 21, "name": "Rector Coordinator"}, {"id": 22, "name": "Rector Yardimcisi / Vice Rector"}, {"id": 23, "name": "School of Foreign Languages"}, {"id": 24, "name": "School of Physical Education and Sports Director"}, {"id": 25, "name": "Yunus Emre Institute"}
    ]

    STAFF_DATA = [
        {"sql_id": 1, "full_name": "Assoc. Prof. Dr. Aprel ATAMGAZIYEV", "title": "Assoc. Prof. Dr.", "department_id": 11}, {"sql_id": 2, "full_name": "Assist. Prof. Dr. Ayse S. BEYLI", "title": "Asst. Prof. Dr.", "department_id": 11}, {"sql_id": 3, "full_name": "Assist. Prof. Dr. Isme ROSYIDAH", "title": "Asst. Prof.", "department_id": 11}, {"sql_id": 4, "full_name": "Assist. Prof. Dr. Lokman GOKCE", "title": "Asst. Prof.", "department_id": 2}, {"sql_id": 5, "full_name": "Assist. Prof. Dr. Mostafa Ayazali Mobarhan", "title": "Asst. Prof.", "department_id": 1}, {"sql_id": 6, "full_name": "Assist. Prof. Dr. Murat ATES", "title": "Asst. Prof.", "department_id": 1}, {"sql_id": 7, "full_name": "Assist. Prof. Dr. Rasime KAPTANLAR", "title": "Asst. Prof.", "department_id": 2}, {"sql_id": 8, "full_name": "Assist. Prof. Dr. Saqra KAIN", "title": "Asst. Prof.", "department_id": 1}, {"sql_id": 9, "full_name": "Assist. Prof. Dr. Sultan KARA", "title": "Asst. Prof.", "department_id": 1}, {"sql_id": 10, "full_name": "Assist. Prof. Dr. Tojara LALIZO", "title": "Asst. Prof.", "department_id": 15}, {"sql_id": 11, "full_name": "Asst. Prof. Dr. Wael JABUR", "title": "Asst. Prof. Dr.", "department_id": 2}, {"sql_id": 12, "full_name": "Assoc. Prof. Dr. Aminreza RAMMANESH", "title": "Assoc. Prof. Dr.", "department_id": 1}, {"sql_id": 13, "full_name": "Assoc. Prof. Dr. Basil OKIY", "title": "Assoc. Prof. Dr.", "department_id": 2}, {"sql_id": 14, "full_name": "Assoc. Prof. Dr. Fevad KARIM GHALEH JOUGI", "title": "Assoc. Prof. Dr.", "department_id": 2}, {"sql_id": 15, "full_name": "Assoc. Prof. Dr. Firat OZAL", "title": "Assoc. Prof. Dr.", "department_id": 21}, {"sql_id": 16, "full_name": "Assoc. Prof. Dr. Hourakhsh A. NIAZOURY", "title": "Assoc. Prof. Dr.", "department_id": 2}, {"sql_id": 17, "full_name": "Assoc. Prof. Dr. Pejman LOTFIABADI", "title": "Assoc. Prof. Dr.", "department_id": 9}, {"sql_id": 18, "full_name": "Assoc. Prof. Dr. Pouya ZAFARI", "title": "Assoc. Prof. Dr.", "department_id": 2}, {"sql_id": 19, "full_name": "Asst. Derya GEVEN", "title": "Asst. Prof.", "department_id": 1}, {"sql_id": 20, "full_name": "Asst. Prof. Dr. Ali Hayye Beyoglu TAHIROGLU", "title": "Asst. Prof. Dr.", "department_id": 15}, {"sql_id": 21, "full_name": "Asst. Prof. Dr. Cemaliye BEYLI", "title": "Asst. Prof. Dr.", "department_id": 11}, {"sql_id": 22, "full_name": "Asst. Prof. Dr. Dervis USTUNYER", "title": "Asst. Prof. Dr.", "department_id": 1}, {"sql_id": 23, "full_name": "Asst. Prof. Dr. E. LALE TIRELI", "title": "Asst. Prof. Dr.", "department_id": 1}, {"sql_id": 24, "full_name": "Asst. Prof. Dr. Farit RIANE", "title": "Asst. Prof. Dr.", "department_id": 2}, {"sql_id": 25, "full_name": "Asst. Prof. Dr. Gulnur AYDIN", "title": "Asst. Prof. Dr.", "department_id": 1}, {"sql_id": 26, "full_name": "Asst. Prof. Dr. Hande DURMUSOGLU", "title": "Asst. Prof. Dr.", "department_id": 1}, {"sql_id": 27, "full_name": "Asst. Prof. Dr. H. M. Pinar SALI", "title": "Asst. Prof. Dr.", "department_id": 15}, {"sql_id": 28, "full_name": "Asst. Prof. Dr. Hasan OZDAL", "title": "Asst. Prof. Dr.", "department_id": 17}, {"sql_id": 29, "full_name": "Asst. Prof. Dr. K. M. O. OBIOLA", "title": "Asst. Prof. Dr.", "department_id": 11}, {"sql_id": 30, "full_name": "Asst. Prof. Dr. Meryem KAMIL", "title": "Asst. Prof. Dr.", "department_id": 2}, {"sql_id": 31, "full_name": "Asst. Prof. Dr. Pinar OZCAN", "title": "Asst. Prof. Dr.", "department_id": 1}, {"sql_id": 32, "full_name": "Asst. Prof. Dr. R. GHAFFARZADEHNAHAVAND", "title": "Asst. Prof. Dr.", "department_id": 2}, {"sql_id": 33, "full_name": "Asst. Prof. Dr. Vecide KOSE", "title": "Asst. Prof. Dr.", "department_id": 1}, {"sql_id": 34, "full_name": "Asst. Prof. Dr. Zeina ATASSI", "title": "Asst. Prof. Dr.", "department_id": 12}, {"sql_id": 35, "full_name": "Asst. Prof. Dr. Ziba ASSININI", "title": "Asst. Prof. Dr.", "department_id": 12}, {"sql_id": 36, "full_name": "Asst. Prof. A. R. O. JABUR", "title": "Asst. Prof. Dr.", "department_id": 2}, {"sql_id": 37, "full_name": "Asst. Prof. Merve KAMIL", "title": "Asst. Prof. Dr.", "department_id": 2}, {"sql_id": 38, "full_name": "Asst. Prof. Merve UYSAL", "title": "Asst. Prof. Dr.", "department_id": 11}, {"sql_id": 39, "full_name": "Dr. ALEKSANDR LAKTIONOV", "title": "Dr.", "department_id": 2}, {"sql_id": 40, "full_name": "Dr. ALIREZA MAGHSOUD LOU", "title": "Dr.", "department_id": 15}, {"sql_id": 41, "full_name": "Dr. A. P. E. OJO", "title": "Dr.", "department_id": 12}, {"sql_id": 42, "full_name": "Dr. Alex GONC", "title": "Dr.", "department_id": 1}, {"sql_id": 43, "full_name": "Dr. Ammar MENDJIA", "title": "Dr.", "department_id": 2}, {"sql_id": 44, "full_name": "Dr. Kamil O. OBIOLA", "title": "Dr.", "department_id": 1}, {"sql_id": 45, "full_name": "Dr. Marie BAMBA", "title": "Dr.", "department_id": 21}, {"sql_id": 46, "full_name": "Dr. MUSTAFA AL BARDI", "title": "Dr.", "department_id": 1}, {"sql_id": 47, "full_name": "Dr. Olumidebe Mukwel KWONKKE", "title": "Dr.", "department_id": 1}, {"sql_id": 48, "full_name": "Dr. Tarek ELSALEH", "title": "Dr.", "department_id": 10}, {"sql_id": 49, "full_name": "Instructor Ali BAHADIR", "title": "Instructor", "department_id": 20}, {"sql_id": 50, "full_name": "Instructor Esma Deren Ozdalcin", "title": "Instructor", "department_id": 20}, {"sql_id": 51, "full_name": "Instructor Nil AGABEYOGLU", "title": "Instructor", "department_id": 12}, {"sql_id": 52, "full_name": "Lecturer Fatma D. KAZIMOGLU", "title": "Lecturer", "department_id": 12}, {"sql_id": 53, "full_name": "Lecturer Gokce OZKARAN", "title": "Lecturer", "department_id": 12}, {"sql_id": 54, "full_name": "Lecturer Berfu CELEBI", "title": "Lecturer", "department_id": 2}, {"sql_id": 55, "full_name": "Lecturer Bulent AYTAC", "title": "Lecturer", "department_id": 1}, {"sql_id": 56, "full_name": "Lecturer Gabriel NIENDHI", "title": "Lecturer", "department_id": 1}, {"sql_id": 57, "full_name": "Lecturer Ibrahim Y. GUNERI", "title": "Lecturer", "department_id": 1}, {"sql_id": 58, "full_name": "Lecturer Olatehan EBIWOWO", "title": "Lecturer", "department_id": 2}, {"sql_id": 59, "full_name": "Lecturer Salar FARAJI", "title": "Lecturer", "department_id": 15}, {"sql_id": 60, "full_name": "Lecturer Sengul AYGUN", "title": "Lecturer", "department_id": 1}, {"sql_id": 61, "full_name": "Lecturer Ugurcan TASDELEN", "title": "Lecturer", "department_id": 1}, {"sql_id": 62, "full_name": "Lecturer Yesim M. P. GUNAY", "title": "Lecturer", "department_id": 15}, {"sql_id": 63, "full_name": "Lecturer Zeynep DILNIHIN BAYRAM", "title": "Lecturer", "department_id": 1}, {"sql_id": 64, "full_name": "Prof. Dr. ABDELKADIR GUL", "title": "Prof. Dr.", "department_id": 2}, {"sql_id": 65, "full_name": "Prof. Dr. Abdulkadir OZDE", "title": "Prof. Dr.", "department_id": 1}, {"sql_id": 66, "full_name": "Prof. Dr. Ali Murat KUNZI", "title": "Prof. Dr.", "department_id": 2}, {"sql_id": 67, "full_name": "Prof. Dr. BASHIR A. OMAR", "title": "Prof. Dr.", "department_id": 2}, {"sql_id": 68, "full_name": "Prof. Dr. BIDO", "title": "Prof. Dr.", "department_id": 22}, {"sql_id": 69, "full_name": "Prof. Dr. E. Osman EGESIOGLU", "title": "Prof. Dr.", "department_id": 2}, {"sql_id": 70, "full_name": "Prof. Dr. Elif Yesim USTUN", "title": "Prof. Dr.", "department_id": 1}, {"sql_id": 71, "full_name": "Prof. Dr. Evren HINCAL", "title": "Prof. Dr.", "department_id": 1}, {"sql_id": 72, "full_name": "Prof. Dr. Gsemra OKSUZOGLU", "title": "Prof. Dr.", "department_id": 10}, {"sql_id": 73, "full_name": "Prof. Dr. Ibrahim Levent TANMAN", "title": "Prof. Dr.", "department_id": 2}, {"sql_id": 74, "full_name": "Prof. Dr. Isa DAURA", "title": "Prof. Dr.", "department_id": 2}, {"sql_id": 75, "full_name": "R. Asst. Alireza KERMANI", "title": "R. Asst.", "department_id": 2}, {"sql_id": 76, "full_name": "R. Asst. Dr. Aytac Y. P. UCANSUOGLU", "title": "R. Asst.", "department_id": 1}, {"sql_id": 77, "full_name": "R. Asst. Caralekwa Nnveka ONYEZEU", "title": "R. Asst.", "department_id": 2}, {"sql_id": 78, "full_name": "R. Asst. E. D. GORMEZLI", "title": "R. Asst.", "department_id": 1}, {"sql_id": 79, "full_name": "R. Asst. Imane BOUMEDINA", "title": "R. Asst.", "department_id": 1}, {"sql_id": 80, "full_name": "R. Asst. M. A. ISLAM", "title": "R. Asst.", "department_id": 1}, {"sql_id": 81, "full_name": "Sen. Inst. ABBAZ BABAYI", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 82, "full_name": "Sen. Inst. Ata CELEBI", "title": "Sen. Inst.", "department_id": 2}, {"sql_id": 83, "full_name": "Sen. Inst. Ayla B. B. DURAN", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 84, "full_name": "Sen. Inst. Ayse OZKOLAY", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 85, "full_name": "Sen. Inst. Cigdem M. CILASUN", "title": "Sen. Inst.", "department_id": 20}, {"sql_id": 86, "full_name": "Sen. Inst. Derk KABA", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 87, "full_name": "Sen. Inst. DICLE SOZER", "title": "Sen. Inst.", "department_id": 9}, {"sql_id": 88, "full_name": "Sen. Inst. Ece UYSAL", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 89, "full_name": "Sen. Inst. Ecem SUHYACINA", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 90, "full_name": "Sen. Inst. FUNDA BAGCI", "title": "Sen. Inst.", "department_id": 21}, {"sql_id": 91, "full_name": "Sen. Inst. Gaelle YOUBI", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 92, "full_name": "Sen. Inst. I. U. BASSEY", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 93, "full_name": "Sen. Inst. Hussein BAHMANIAN", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 94, "full_name": "Sen. Inst. Josephat Ayobamidele VAUGHAN", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 95, "full_name": "Sen. Inst. Levent ISANOVA", "title": "Sen. Inst.", "department_id": 2}, {"sql_id": 96, "full_name": "Sen. Inst. M. B. JALLOW", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 97, "full_name": "Sen. Inst. Musret K. KAHVECIOGLU", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 98, "full_name": "Sen. Inst. Nihat BUYUKOGLU", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 99, "full_name": "Sen. Inst. Nurcan S. R. BILGE", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 100, "full_name": "Sen. Inst. Dennis UZUN", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 101, "full_name": "Sen. Inst. Ozlem D. CEYLAN", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 102, "full_name": "Sen. Inst. Rozan DOSTRES", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 103, "full_name": "Sen. Inst. Sacra GAGA", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 104, "full_name": "Sen. Inst. Salomeh DEHGHAN", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 105, "full_name": "Sen. Inst. Silvia SIMKA", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 106, "full_name": "Sen. Inst. Sohila E. TALEBNIA", "title": "Sen. Inst.", "department_id": 2}, {"sql_id": 107, "full_name": "Sen. Inst. Sonia SHOAR", "title": "Sen. Inst.", "department_id": 1}, {"sql_id": 108, "full_name": "Sen. Inst. SUNDAY CHIBONN TASONG", "title": "Sen. Inst.", "department_id": 2}
    ]

    OFFICE_DATA = [
        {"office_number": "AS - 111", "capacity": 6, "building_id": 2, "floor": 2, "department_id": 1}, {"office_number": "AS - 112", "capacity": 8, "building_id": 2, "floor": 2, "department_id": 19}, {"office_number": "AS - 113", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 11}, {"office_number": "AS - 114", "capacity": 8, "building_id": 2, "floor": 2, "department_id": 11}, {"office_number": "AS - 115", "capacity": 7, "building_id": 2, "floor": 2, "department_id": 15}, {"office_number": "AS - 116", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 10}, {"office_number": "AS - 117", "capacity": 7, "building_id": 2, "floor": 2, "department_id": 15}, {"office_number": "AS - 118", "capacity": 6, "building_id": 2, "floor": 2, "department_id": 10}, {"office_number": "AS - 119", "capacity": 6, "building_id": 2, "floor": 2, "department_id": 16}, {"office_number": "AS - 120", "capacity": 7, "building_id": 2, "floor": 2, "department_id": 11}, {"office_number": "AS - 121", "capacity": 6, "building_id": 2, "floor": 2, "department_id": 11}, {"office_number": "AS - 122", "capacity": 8, "building_id": 2, "floor": 2, "department_id": 17}, {"office_number": "AS - 123", "capacity": 10, "building_id": 2, "floor": 2, "department_id": 1}, {"office_number": "AS - 123A", "capacity": 8, "building_id": 2, "floor": 2, "department_id": 23}, {"office_number": "AS - 124", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 15}, {"office_number": "AS - 125", "capacity": 4, "building_id": 2, "floor": 2, "department_id": 9}, {"office_number": "AS - 126", "capacity": 4, "building_id": 2, "floor": 2, "department_id": 12}, {"office_number": "AS - 127", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 15}, {"office_number": "AS - 128", "capacity": 4, "building_id": 2, "floor": 2, "department_id": 13}, {"office_number": "AS - 129", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 11}, {"office_number": "AS - 130", "capacity": 6, "building_id": 2, "floor": 2, "department_id": 1}, {"office_number": "AS - 131", "capacity": 4, "building_id": 2, "floor": 2, "department_id": 14}, {"office_number": "AS - 132", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 25}, {"office_number": "AS - 133", "capacity": 6, "building_id": 2, "floor": 2, "department_id": 21}, {"office_number": "AS - 134", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 2}, {"office_number": "AS - 135", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 1}, {"office_number": "AS - 136", "capacity": 6, "building_id": 2, "floor": 2, "department_id": 3}, {"office_number": "AS - 137", "capacity": 5, "building_id": 2, "floor": 2, "department_id": 24}, {"office_number": "AS - 138", "capacity": 9, "building_id": 2, "floor": 2, "department_id": 1}, {"office_number": "AS - 139", "capacity": 6, "building_id": 2, "floor": 2, "department_id": 1}, {"office_number": "AS - 140", "capacity": 8, "building_id": 2, "floor": 2, "department_id": 1}, {"office_number": "Rector Office", "capacity": 6, "building_id": 9, "floor": 1, "department_id": 22}, {"office_number": "Engineering Dean", "capacity": 8, "building_id": 6, "floor": 1, "department_id": 7}, {"office_number": "Education Dean", "capacity": 6, "building_id": 5, "floor": 1, "department_id": 6}, {"office_number": "Law Dean", "capacity": 6, "building_id": 7, "floor": 1, "department_id": 8}, {"office_number": "Economics Dean", "capacity": 6, "building_id": 4, "floor": 1, "department_id": 5}, {"office_number": "Arts & Sciences Dean", "capacity": 7, "building_id": 4, "floor": 1, "department_id": 4}, {"office_number": "Medicosocial", "capacity": 5, "building_id": 8, "floor": 2, "department_id": 18}, {"office_number": "(No Door Sign)", "capacity": 0, "building_id": 1, "floor": 2, "department_id": 20}
    ]

    print("🏗️ Processing Buildings...")
    b_map = {}
    for b_data in BUILDINGS_DATA:
        obj, _ = Building.objects.update_or_create(
            building_id=b_data['id'],
            defaults={'code': b_data['code'][:10], 'name': b_data['name']}
        )
        b_map[b_data['id']] = obj

    print("📚 Processing Departments...")
    d_map = {}
    for d_data in DEPARTMENTS_DATA:
        obj, _ = Department.objects.update_or_create(
            department_id=d_data['id'],
            defaults={'name': d_data['name']}
        )
        d_map[d_data['id']] = obj

    print("👨‍🏫 Processing Staff...")
    for s_data in STAFF_DATA:
        dept = d_map.get(s_data['department_id'])
        Faculty.objects.update_or_create(
            staff_id=str(s_data['sql_id']),
            defaults={
                'full_name': s_data['full_name'],
                'department': dept
            }
        )

    print("🚪 Processing Offices...")
    for o_data in OFFICE_DATA:
        b = b_map.get(o_data['building_id'])
        dept = d_map.get(o_data['department_id'])
        
        if b:
            Office.objects.update_or_create(
                room_number=o_data['office_number'],
                defaults={
                    'building': b,
                    'floor_id': o_data['floor'], 
                    'capacity': o_data['capacity'],
                    'department': dept
                }
            )

    print("👤 Checking User Accounts...")
    teacher_group, _ = Group.objects.get_or_create(name="teacher")
    
    if not User.objects.filter(username="admin").exists():
        User.objects.create_superuser("admin", "admin@final.edu.tr", DEFAULT_PASS)

    faculties = Faculty.objects.all()
    for f in faculties:
        base = slug_username(f.full_name)
        if not base or User.objects.filter(username=base).exists():
            continue

        username = unique_username(base)
        email = f"{username}@final.edu.tr"
        user = User.objects.create_user(username=username, email=email, password=DEFAULT_PASS)
        teacher_group.user_set.add(user)

if __name__ == "__main__":
    create_full_data()
    print("\n✅ FULL REAL DATA LOADED SUCCESSFULLY!")
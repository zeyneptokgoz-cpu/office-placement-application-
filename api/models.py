# api/models.py
from django.db import models
from django.utils import timezone

# ---------------------------------------------------------------------------
# ÖNEMLİ NOT:
# Bu modeller, 'officeplacement_backup.sql' dosyasından yüklenen
# MEVCUT bir veritabanını okumak için 'db_table' ve 'db_column' kullanır.
# Bu dosyayı kaydettikten sonra 'python manage.py migrate' KOMUTUNU
# ÇALIŞTIRMAYIN. Sadece 'runserver' komutunu yeniden başlatın.
# ---------------------------------------------------------------------------


# --- YARDIMCI MODELLER (ForeignKey'ler için gerekli) ---

# Model: FacultyDivision (Fakülte Binası/Bölümü)
# .sql dosyasındaki 'faculties' tablosuna bağlanır
# (Bu, 'staff' (personel) modelinden farklıdır)
class FacultyDivision(models.Model):
    faculty_id = models.AutoField(primary_key=True)
    name = models.TextField(unique=True)

    class Meta:
        managed = False # Django'nun bu tabloya dokunmamasını söyler
        db_table = 'faculties'
        verbose_name_plural = "Faculty Divisions"

    def __str__(self):
        return self.name

# Model: Title (Unvan)
# .sql dosyasındaki 'titles' tablosuna bağlanır
class Title(models.Model):
    title_id = models.AutoField(primary_key=True)
    title_name = models.TextField(unique=True)

    class Meta:
        managed = False # Django'nun bu tabloya dokunmamasını söyler
        db_table = 'titles'

    def __str__(self):
        return self.title_name


# --- ANA MODELLER (ViewSet'leriniz tarafından kullanılan) ---

# Model 1: Building (Bina)
# .sql dosyasındaki 'buildings' tablosuna bağlanır
class Building(models.Model):
    building_id = models.AutoField(primary_key=True)
    code = models.TextField(unique=True)
    name = models.TextField(null=True, blank=True)
    description = models.TextField(null=True, blank=True)

    class Meta:
        managed = False # Django'nun bu tabloya dokunmamasını söyler
        db_table = 'buildings'

    def __str__(self):
        return self.name or self.code

# Model 2: Floor (Kat)
# .sql dosyasındaki 'floors' tablosuna bağlanır
# (Office modeli buna ihtiyaç duyduğu için ekledik)
class Floor(models.Model):
    floor_id = models.AutoField(primary_key=True)
    building = models.ForeignKey(Building, on_delete=models.DO_NOTHING, db_column='building_id')
    floor_number = models.IntegerField()

    class Meta:
        managed = False # Django'nun bu tabloya dokunmamasını söyler
        db_table = 'floors'
        unique_together = (('building', 'floor_number'),)

    def __str__(self):
        return f"{self.building.code} - Kat {self.floor_number}"

# Model 3: Department (Departman)
# .sql dosyasındaki 'departments' tablosuna bağlanır
class Department(models.Model):
    department_id = models.AutoField(primary_key=True)
    name = models.TextField(unique=True)
    faculty = models.ForeignKey(FacultyDivision, on_delete=models.DO_NOTHING, db_column='faculty_id', null=True, blank=True)

    class Meta:
        managed = False # Django'nun bu tabloya dokunmamasını söyler
        db_table = 'departments'

    def __str__(self):
        return self.name

# Model 4: Faculty (Personel)
# DİKKAT: Bu model, sizin 'FacultyViewSet'iniz için .sql dosyasındaki 'staff' tablosuna bağlanır.
class Faculty(models.Model):
    staff_id = models.AutoField(primary_key=True)
    full_name = models.TextField(unique=True)
    title = models.ForeignKey(Title, on_delete=models.DO_NOTHING, db_column='title_id', null=True, blank=True)
    primary_department = models.ForeignKey(Department, on_delete=models.DO_NOTHING, db_column='primary_department_id', null=True, blank=True, related_name='staff_members')

    class Meta:
        managed = False # Django'nun bu tabloya dokunmamasını söyler
        db_table = 'staff' # <-- 'Faculty' modelini 'staff' tablosuna bağlıyoruz
        verbose_name_plural = "Faculty (Staff)"

    def __str__(self):
        return self.full_name

# Model 5: Office (Ofis)
# DİKKAT: Bu model, sizin 'OfficeViewSet'iniz için .sql dosyasındaki 'rooms' tablosuna bağlanır.
class Office(models.Model):
    room_id = models.AutoField(primary_key=True)
    room_number = models.TextField(unique=True)
    capacity = models.IntegerField(null=True, blank=True)
    
    # .sql dosyasındaki 'rooms' tablosundaki foreign key sütun adları
    department = models.ForeignKey(Department, on_delete=models.DO_NOTHING, db_column='department_id', null=True, blank=True)
    building = models.ForeignKey(Building, on_delete=models.DO_NOTHING, db_column='building_id', null=True, blank=True)
    floor = models.ForeignKey(Floor, on_delete=models.DO_NOTHING, db_column='floor_id', null=True, blank=True)

    class Meta:
        managed = False # Django'nun bu tabloya dokunmamasını söyler
        db_table = 'rooms' # <-- 'Office' modelini 'rooms' tablosuna bağlıyoruz

    def __str__(self):
        return self.room_number

# Model 6: Assignment (Yerleşim/Atama)
# DİKKAT: Bu model, sizin 'AssignmentViewSet'iniz için .sql dosyasındaki 'staff_room_history' tablosuna bağlanır.
class Assignment(models.Model):
    history_id = models.AutoField(primary_key=True)
    
    # 'faculty' -> 'staff' tablosuna bağlanır ('Faculty' modelini kullanarak)
    faculty = models.ForeignKey(Faculty, on_delete=models.DO_NOTHING, db_column='staff_id')
    
    # 'office' -> 'rooms' tablosuna bağlanır ('Office' modelini kullanarak)
    office = models.ForeignKey(Office, on_delete=models.DO_NOTHING, db_column='room_id')
    
    # 'start_date' -> 'valid_from' sütununa bağlanır
    start_date = models.DateField(db_column='valid_from', null=True, blank=True)
    
    # 'end_date' -> 'valid_to' sütununa bağlanır
    end_date = models.DateField(db_column='valid_to', null=True, blank=True)
    
    notes = models.TextField(null=True, blank=True)

    class Meta:
        managed = False # Django'nun bu tabloya dokunmamasını söyler
        db_table = 'staff_room_history' # <-- 'Assignment' modelini 'staff_room_history' tablosuna bağlıyoruz

    def __str__(self):
        status = " (Aktif)" if self.end_date is None else f" (Ayrıldı: {self.end_date})"
        return f"{self.faculty.full_name} -> {self.office.room_number} {status}"
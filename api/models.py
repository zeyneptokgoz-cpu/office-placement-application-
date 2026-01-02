from django.db import models
from django.utils import timezone

class Building(models.Model):
    building_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    code = models.CharField(max_length=10)

    class Meta:
        db_table = 'buildings'
        managed = False

    def __str__(self):
        return self.name

class Department(models.Model):
    department_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)

    class Meta:
        db_table = 'departments'
        managed = False

    def __str__(self):
        return self.name

class Faculty(models.Model):
    staff_id = models.AutoField(primary_key=True)
    full_name = models.CharField(max_length=255)
    title_id = models.IntegerField(null=True, blank=True)
    department = models.ForeignKey(Department, on_delete=models.SET_NULL, null=True, blank=True, db_column='primary_department_id')

    class Meta:
        db_table = 'staff'
        managed = False
        verbose_name = "Faculty"
        verbose_name_plural = "Faculty Members"

    def __str__(self):
        return self.full_name

class Office(models.Model):
    room_id = models.AutoField(primary_key=True)
    room_number = models.CharField(max_length=50)
    capacity = models.IntegerField(null=True, blank=True)
    
    # --- İLİŞKİLER GERİ GELDİ ---
    # Artık sayı değil, Bina ve Departman objesi olarak bağlıyoruz
    building = models.ForeignKey(Building, on_delete=models.DO_NOTHING, db_column='building_id')
    department = models.ForeignKey(Department, on_delete=models.SET_NULL, null=True, blank=True, db_column='department_id')
    floor_id = models.IntegerField(null=True, blank=True)

    class Meta:
        db_table = 'rooms'
        managed = False
        verbose_name = "Office"
        verbose_name_plural = "Offices"

    def __str__(self):
        return f"{self.room_number} ({self.building.name})"

class Assignment(models.Model):
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE, db_column='staff_id', primary_key=True)
    office = models.ForeignKey(Office, on_delete=models.CASCADE, db_column='room_id')
    start_date = models.DateField(db_column='valid_from', default=timezone.now) 
    end_date = models.DateField(db_column='valid_to', null=True, blank=True)

    class Meta:
        db_table = 'staff_room_history'
        managed = False
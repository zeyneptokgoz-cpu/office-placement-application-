# api/admin.py
from django.contrib import admin
from .models import Building, Department, Faculty, Office, Assignment

# --- Daha Kullanışlı Admin Arayüzü İçin Ekstra Ayarlar ---

class AssignmentInline(admin.TabularInline):
    """
    Bu, bir Ofis'in veya Personel'in detay sayfasındayken
    ilgili atamaları alt alta görmemizi sağlar.
    """
    model = Assignment
    extra = 0  # Varsayılan olarak fazladan boş form gösterme
    autocomplete_fields = ['faculty', 'office'] # Arama kutusu ile personel/ofis seçimi


@admin.register(Building)
class BuildingAdmin(admin.ModelAdmin):
    list_display = ('name', 'code')
    search_fields = ('name', 'code')


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    search_fields = ('name',)


@admin.register(Faculty)
class FacultyAdmin(admin.ModelAdmin):
    list_display = ('full_name', 'title', 'department')
    list_filter = ('department', 'title')
    search_fields = ('full_name', 'email', 'staff_id')
    inlines = [AssignmentInline] # Personel sayfasında atamalarını göster


@admin.register(Office)
class OfficeAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'building', 'floor', 'capacity', 'current_occupancy', 'is_over_capacity')
    list_filter = ('building', 'floor', 'capacity', 'departments')
    search_fields = ('office_number', 'building__name', 'departments__name')
    autocomplete_fields = ['departments'] # Çoklu departman seçimini kolaylaştırır
    inlines = [AssignmentInline] # Ofis sayfasında atamalarını göster
    
    # 'current_occupancy' ve 'is_over_capacity' özellikleri models.py'den geliyor
    # Bunları admin panelinde göstermek çok faydalıdır.


@admin.register(Assignment)
class AssignmentAdmin(admin.ModelAdmin):
    list_display = ('faculty', 'office', 'start_date', 'end_date')
    list_filter = ('start_date', 'end_date', 'office__building')
    search_fields = ('faculty__full_name', 'office__office_number')
    autocomplete_fields = ['faculty', 'office']
    date_hierarchy = 'start_date' # Tarihe göre hızlı filtreleme
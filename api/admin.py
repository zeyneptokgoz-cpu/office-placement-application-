from django.contrib import admin
from .models import Building, Department, Faculty, Office, Assignment

class AssignmentInline(admin.TabularInline):
    model = Assignment
    extra = 0
    fields = ('office', 'start_date', 'end_date')
    can_delete = False

@admin.register(Building)
class BuildingAdmin(admin.ModelAdmin):
    list_display = ('name', 'code')
    search_fields = ('name', 'code')

@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)

@admin.register(Faculty)
class FacultyAdmin(admin.ModelAdmin):
    list_display = ('full_name', 'department', 'title_id')
    list_filter = ('department',)
    search_fields = ('full_name', 'staff_id')
    inlines = [AssignmentInline]

@admin.register(Office)
class OfficeAdmin(admin.ModelAdmin):
    # Tekrar 'building' ismini kullanabiliriz çünkü ilişki kuruldu
    list_display = ('room_number', 'building', 'floor_id', 'capacity')
    list_filter = ('building', 'floor_id')
    search_fields = ('room_number',)

@admin.register(Assignment)
class AssignmentAdmin(admin.ModelAdmin):
    list_display = ('faculty', 'office', 'start_date', 'end_date')
    list_filter = ('start_date', 'end_date')
    search_fields = ('faculty__full_name', 'office__room_number')
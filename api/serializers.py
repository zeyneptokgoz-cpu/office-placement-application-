# api/serializers.py
from rest_framework import serializers
from .models import (
    Building,
    Department,
    Faculty,      # Bu, .sql'deki 'staff' tablosuna bağlı
    Office,       # Bu, .sql'deki 'rooms' tablosuna bağlı
    Assignment,   # Bu, .sql'deki 'staff_room_history' tablosuna bağlı
    Floor,
    Title,
    FacultyDivision
)

# --- ANA MODELLER İÇİN SERIALIZER'LAR ---

class BuildingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Building
        fields = ['building_id', 'code', 'name', 'description']

class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = ['department_id', 'name', 'faculty']

class FacultySerializer(serializers.ModelSerializer):
    title = serializers.StringRelatedField()
    primary_department = serializers.StringRelatedField()

    class Meta:
        model = Faculty
        fields = ['staff_id', 'full_name', 'title', 'primary_department']

class OfficeSerializer(serializers.ModelSerializer):
    department = serializers.StringRelatedField()
    building = serializers.StringRelatedField()
    floor = serializers.StringRelatedField()

    class Meta:
        model = Office
        fields = ['room_id', 'room_number', 'capacity', 'department', 'building', 'floor']

class AssignmentSerializer(serializers.ModelSerializer):
    faculty = serializers.StringRelatedField()
    office = serializers.StringRelatedField()

    class Meta:
        model = Assignment
        fields = ['history_id', 'faculty', 'office', 'start_date', 'end_date', 'notes']

# --- YARDIMCI MODELLER (Gerekirse) ---
class FloorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Floor
        fields = '__all__'

class TitleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Title
        fields = '__all__'
        
class FacultyDivisionSerializer(serializers.ModelSerializer):
    class Meta:
        model = FacultyDivision
        fields = '__all__'
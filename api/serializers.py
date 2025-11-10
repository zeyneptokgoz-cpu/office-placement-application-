# api/serializers.py
from rest_framework import serializers
from .models import (
    Building,
    Department,
    Faculty,
    Office,
    Assignment,
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

# ---------------------------------------------------------------------
# OfficeSerializer'ı 'POST' (YAZMA) İŞLEMİ İÇİN GÜNCELLEDİK
# ---------------------------------------------------------------------
class OfficeSerializer(serializers.ModelSerializer):
    # 'GET' (Okuma) isteklerinde ilişkili modelin adını göstermek için
    # 'source' modeldeki alan adını, 'read_only=True' ise sadece okumada
    # kullanılacağını belirtir.
    department_name = serializers.StringRelatedField(source='department', read_only=True)
    building_name = serializers.StringRelatedField(source='building', read_only=True)
    floor_name = serializers.StringRelatedField(source='floor', read_only=True)

    class Meta:
        model = Office
        fields = [
            'room_id', 
            'room_number', 
            'capacity', 
            
            # 'POST' (Yazma) işlemi için bu alanları kullanacağız.
            # Bunlar JSON'da 'building: 1' gibi ID'leri kabul edecekler.
            'department', 
            'building', 
            'floor',
            
            # 'GET' (Okuma) işlemi için bu alanları göstereceğiz.
            'department_name', 
            'building_name', 
            'floor_name'
        ]
        
        # 'POST' isteğinde ID'leri aldığımız için, 'GET' isteğinde
        # bu ID'leri tekrar göstermeye gerek yok (isimlerini zaten gösteriyoruz).
        # Bu nedenle 'write_only' (sadece yaz) olarak işaretliyoruz.
        extra_kwargs = {
            'department': {'write_only': True},
            'building': {'write_only': True},
            'floor': {'write_only': True},
        }

class AssignmentSerializer(serializers.ModelSerializer):
    # Bu serializer'ı da OfficeSerializer'daki gibi güncelliyoruz
    
    # Okuma (GET) için
    faculty_name = serializers.StringRelatedField(source='faculty', read_only=True)
    office_name = serializers.StringRelatedField(source='office', read_only=True)

    class Meta:
        model = Assignment
        fields = [
            'history_id', 
            
            # Yazma (POST) için (ID kabul edecekler)
            'faculty', 
            'office', 
            
            'start_date', 
            'end_date', 
            'notes',
            
            # Okuma (GET) için
            'faculty_name', 
            'office_name'
        ]
        extra_kwargs = {
            'faculty': {'write_only': True},
            'office': {'write_only': True},
        }

# --- YARDIMCI MODELLER (Aynı kalabilir) ---
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
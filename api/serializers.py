# api/serializers.py
from rest_framework import serializers

# --- YENİ IMPORTLAR (Kayıt için) ---
from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from rest_framework.validators import UniqueValidator

# Django'nun varsayılan 'User' modelini alıyoruz
User = get_user_model()
# -----------------------------------


# --- MEVCUT IMPORTLAR (Modeller için) ---
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


# ---------------------------------------------------------------------
# YENİ KULLANICI KAYIT (SIGN-UP) SERIALIZER'I
# ---------------------------------------------------------------------
class RegisterSerializer(serializers.ModelSerializer):
    # 'email' alanının benzersiz (unique) olmasını zorunlu kılıyoruz
    email = serializers.EmailField(
        required=True,
        validators=[UniqueValidator(queryset=User.objects.all())]
    )
    
    # Sadece yazılabilir (write_only) iki şifre alanı ekliyoruz
    # 'write_only=True' -> Bu alanlar 'GET' isteklerinde (cevapta) görünmez
    password = serializers.CharField(
        write_only=True, 
        required=True, 
        validators=[validate_password], # Django'nun şifre zorluk kontrolü
        style={'input_type': 'password'} # API arayüzünde şifre gibi görünmesi için
    )
    password2 = serializers.CharField(
        write_only=True, 
        required=True, 
        style={'input_type': 'password'}
    )

    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'password2')
        extra_kwargs = {
            'username': {'required': True}
        }

    def validate(self, attrs):
        """
        İki şifrenin birbiriyle eşleşip eşleşmediğini kontrol eder.
        """
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Passwords do not match."})
        
        # 'password2' alanına artık ihtiyacımız kalmadı, veritabanına gitmemeli
        attrs.pop('password2')
        return attrs

    def create(self, validated_data):
        """
        Doğrulanmış veriden yeni bir kullanıcı oluşturur ve şifreyi şifreler (hash).
        """
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return user


# ---------------------------------------------------------------------
# MEVCUT ANA SERIALIZER'LAR (CRUD için)
# ---------------------------------------------------------------------

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
    # 'GET' (Okuma) isteklerinde ilişkili modelin adını göstermek için
    department_name = serializers.StringRelatedField(source='department', read_only=True)
    building_name = serializers.StringRelatedField(source='building', read_only=True)
    floor_name = serializers.StringRelatedField(source='floor', read_only=True)

    class Meta:
        model = Office
        fields = [
            'room_id', 
            'room_number', 
            'capacity', 
            
            # 'POST' (Yazma) işlemi için
            'department', 
            'building', 
            'floor',
            
            # 'GET' (Okuma) işlemi için
            'department_name', 
            'building_name', 
            'floor_name'
        ]
        extra_kwargs = {
            'department': {'write_only': True},
            'building': {'write_only': True},
            'floor': {'write_only': True},
        }

class AssignmentSerializer(serializers.ModelSerializer):
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


# --- MEVCUT YARDIMCI MODELLER İÇİN SERIALIZER'LAR ---
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
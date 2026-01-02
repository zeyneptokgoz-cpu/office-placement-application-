from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Building, Department, Faculty, Office, Assignment

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    class Meta:
        model = User
        fields = ('username', 'password', 'email')
    def create(self, validated_data):
        return User.objects.create_user(**validated_data)

class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = '__all__'

class BuildingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Building
        fields = '__all__'

class FacultySerializer(serializers.ModelSerializer):
    department = DepartmentSerializer(read_only=True)
    class Meta:
        model = Faculty
        fields = ['staff_id', 'full_name', 'title_id', 'department']

class OfficeSerializer(serializers.ModelSerializer):
    # İlişkili verileri detaylı göstermek için (Nested Serializer)
    building = BuildingSerializer(read_only=True)
    department = DepartmentSerializer(read_only=True)

    class Meta:
        model = Office
        fields = ['room_id', 'room_number', 'capacity', 'floor_id', 'building', 'department']

class AssignmentSerializer(serializers.ModelSerializer):
    faculty = FacultySerializer(read_only=True)
    office = OfficeSerializer(read_only=True)
    class Meta:
        model = Assignment
        fields = ['faculty', 'office', 'start_date', 'end_date']
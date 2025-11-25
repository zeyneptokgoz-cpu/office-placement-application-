# api/tests.py
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth import get_user_model
from .models import Building, Department, Floor

User = get_user_model()

class UserRegistrationTests(APITestCase):
    """
    Kullanıcı Kayıt (Register) İşlemlerini Test Eder.
    """
    def setUp(self):
        self.register_url = reverse('register')
        self.user_data = {
            'username': 'testrobot',
            'email': 'robot@test.com',
            'password': 'StrongPassword123!',
            'password2': 'StrongPassword123!'
        }

    def test_can_register_user(self):
        # Başarılı kayıt testi
        response = self.client.post(self.register_url, self.user_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.get().username, 'testrobot')

    def test_cannot_register_with_no_data(self):
        # Boş veri ile kayıt engelleme testi
        response = self.client.post(self.register_url, {})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

class OfficePermissionTests(APITestCase):
    """
    Ofis (Office) CRUD işlemleri için Yetki (Permission) Testleri.
    Admin: İzin verilmeli.
    Normal Kullanıcı: Yasaklanmalı.
    """
    def setUp(self):
        # 1. Kullanıcıları Oluştur
        self.admin_user = User.objects.create_superuser(
            username='adminuser', email='admin@test.com', password='Pass123!'
        )
        self.normal_user = User.objects.create_user(
            username='normaluser', email='normal@test.com', password='Pass123!'
        )

        # 2. Bağımlılıkları Oluştur (Foreign Keys)
        # Ayarladığımız 'test_runner' sayesinde bu tablolar hatasız oluşturulacak.
        self.building = Building.objects.create(name="Test Building", code="TB")
        self.dept = Department.objects.create(name="Test Department")
        self.floor = Floor.objects.create(building=self.building, floor_number=1)

        # 3. URL'i Hazırla
        self.office_url = reverse('office-list') 

    def test_admin_can_create_office(self):
        """Test: Admin kullanıcısı ofis oluşturabilmeli (201 Created)"""
        self.client.force_authenticate(user=self.admin_user)
        
        data = {
            "room_number": "ADMIN-ROOM-001",
            "capacity": 5,
            "building": self.building.building_id,
            "department": self.dept.department_id,
            "floor": self.floor.floor_id
        }

        response = self.client.post(self.office_url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_normal_user_cannot_create_office(self):
        """Test: Normal kullanıcı ofis oluşturamamalı (403 Forbidden)"""
        self.client.force_authenticate(user=self.normal_user)
        
        data = {
            "room_number": "HACKER-ROOM-001",
            "capacity": 10,
            "building": self.building.building_id,
            "department": self.dept.department_id,
            "floor": self.floor.floor_id
        }

        response = self.client.post(self.office_url, data)
        
        # Beklentimiz: 403 Forbidden (Yasak)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
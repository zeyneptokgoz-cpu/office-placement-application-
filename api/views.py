# api/views.py
from rest_framework import viewsets, filters, generics
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAdminUser

# --- EKSİK OLAN IMPORT SATIRI BURAYA EKLENDİ ---
from django_filters.rest_framework import DjangoFilterBackend
# ------------------------------------------------

# 403 Forbidden (CSRF) hatasını çözmek için JWTAuthentication import ediyoruz
from rest_framework_simplejwt.authentication import JWTAuthentication

# --- YENİ IMPORTLAR (Kayıt için) ---
from django.contrib.auth import get_user_model
User = get_user_model()
# -----------------------------------


# 'api/models.py' dosyamızdaki GÜNCEL modeller
from .models import (
    Building,
    Department,
    Faculty,      # 'staff' tablosuna bağlı
    Office,       # 'rooms' tablosuna bağlı
    Assignment    # 'staff_room_history' tablosuna bağlı
)

# 'api/serializers.py' dosyamızdaki GÜNCEL serializer'lar
from .serializers import (
    BuildingSerializer,
    DepartmentSerializer,
    FacultySerializer,
    OfficeSerializer,
    AssignmentSerializer,
    RegisterSerializer  # Kayıt Serializer'ı
)


# --- ViewSet'ler (API Endpoint'leri) ---

class BuildingViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Tüm binaları listeler. Sadece okunabilir (ReadOnly).
    .sql'deki 'buildings' tablosunu kullanır.
    """
    queryset = Building.objects.all()
    serializer_class = BuildingSerializer
    permission_classes = [AllowAny] 
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['code', 'name']
    search_fields = ['code', 'name', 'description']

class DepartmentViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Tüm departmanları listeler. Sadece okunabilir (ReadOnly).
    .sql'deki 'departments' tablosunu kullanır.
    """
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    permission_classes = [AllowAny]
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['faculty']
    search_fields = ['name']

class FacultyViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Tüm personeli (Faculty) listeler. Sadece okunabilir (ReadOnly).
    .sql'deki 'staff' tablosunu kullanır.
    """
    queryset = Faculty.objects.all()
    serializer_class = FacultySerializer
    
    # KORUMALI: Sadece JWT token ile giriş yapanlar (admin VEYA testuser1) görebilir
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated] # Salt okunur olduğu için 'IsAuthenticated' kalabilir
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['title', 'primary_department'] 
    search_fields = ['full_name', 'title__title_name', 'primary_department__name']

class OfficeViewSet(viewsets.ModelViewSet):
    """
    Tüm ofisleri (Rooms) listeler ve yönetir (CRUD).
    .sql'deki 'rooms' tablosunu kullanır.
    """
    queryset = Office.objects.all()
    serializer_class = OfficeSerializer
    
    # GÜVENLİK GÜNCELLEMESİ:
    # SADECE Admin olanlar (superuser) POST, PATCH, DELETE yapabilir.
    authentication_classes = [JWTAuthentication] 
    permission_classes = [IsAdminUser] # IsAuthenticated'dan GÜNCELLENDİ
 
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['building', 'floor', 'department', 'capacity']
    search_fields = ['room_number', 'department__name', 'building__code']

class AssignmentViewSet(viewsets.ModelViewSet):
    """
    Tüm personel atamalarını (Staff Room History) listeler ve yönetir (CRUD).
    .sql'deki 'staff_room_history' tablosunu kullanır.
    """
    queryset = Assignment.objects.all()
    serializer_class = AssignmentSerializer
    
    # GÜVENLİK GÜNCELLEMESİ:
    # SADECE Admin olanlar (superuser) POST, PATCH, DELETE yapabilir.
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAdminUser] # IsAuthenticated'dan GÜNCELLENDİ
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['faculty', 'office', 'start_date', 'end_date']
    search_fields = ['faculty__full_name', 'office__room_number', 'notes']


# ---------------------------------------------------------------------
# YENİ KULLANICI KAYIT (SIGN-UP) VIEW'İ
# ---------------------------------------------------------------------
class RegisterView(generics.CreateAPIView):
    """
    Yeni kullanıcıların 'username', 'email' ve 'password' ile
    kayıt olmasını sağlayan endpoint (kapı).
    """
    queryset = User.objects.all()
    # Herkesin (giriş yapmamış olanların bile) erişebilmesi gerekir
    permission_classes = [AllowAny]
    # Bu view, 'api/serializers.py' dosyasındaki RegisterSerializer'ı kullanacak
    serializer_class = RegisterSerializer
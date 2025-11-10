# api/views.py
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated, AllowAny
from django_filters.rest_framework import DjangoFilterBackend

# 403 Forbidden (CSRF) hatasını çözmek için JWTAuthentication import ediyoruz
from rest_framework_simplejwt.authentication import JWTAuthentication

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
    AssignmentSerializer
)


# --- ViewSet'ler (API Endpoint'leri) ---

class BuildingViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Tüm binaları listeler. Sadece okunabilir (ReadOnly).
    .sql'deki 'buildings' tablosunu kullanır.
    """
    queryset = Building.objects.all()
    serializer_class = BuildingSerializer
    # Bu verinin herkese açık (public) olduğunu varsayıyoruz
    permission_classes = [AllowAny] 
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['code', 'name'] # Filtrelenebilir alanlar
    search_fields = ['code', 'name', 'description'] # Aranabilir alanlar

class DepartmentViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Tüm departmanları listeler. Sadece okunabilir (ReadOnly).
    .sql'deki 'departments' tablosunu kullanır.
    """
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer
    # Bu verinin herkese açık (public) olduğunu varsayıyoruz
    permission_classes = [AllowAny]
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['faculty'] # Fakülteye (FacultyDivision) göre filtrele
    search_fields = ['name']

class FacultyViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Tüm personeli (Faculty) listeler. Sadece okunabilir (ReadOnly).
    .sql'deki 'staff' tablosunu kullanır.
    """
    queryset = Faculty.objects.all()
    serializer_class = FacultySerializer
    
    # KORUMALI: Sadece JWT token ile giriş yapanlar görebilir
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated] 
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    # 'Faculty' modelindeki (yani 'staff') doğru alan adları
    filterset_fields = ['title', 'primary_department'] 
    search_fields = ['full_name', 'title__title_name', 'primary_department__name']

class OfficeViewSet(viewsets.ModelViewSet):
    """
    Tüm ofisleri (Rooms) listeler ve yönetir.
    .sql'deki 'rooms' tablosunu kullanır.
    """
    queryset = Office.objects.all()
    serializer_class = OfficeSerializer
    
    # KORUMALI: Sadece JWT token ile giriş yapanlar erişebilir
    authentication_classes = [JWTAuthentication] 
    permission_classes = [IsAuthenticated] 

    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    
    # HATA BURADAYDI: 'departments' (çoğul) yerine 'department' (tekil)
    filterset_fields = ['building', 'floor', 'department', 'capacity']
    
    search_fields = ['room_number', 'department__name', 'building__code']

class AssignmentViewSet(viewsets.ModelViewSet):
    """
    Tüm personel atamalarını (Staff Room History) listeler ve yönetir.
    .sql'deki 'staff_room_history' tablosunu kullanır.
    """
    queryset = Assignment.objects.all()
    serializer_class = AssignmentSerializer
    
    # KORUMALI: Sadece JWT token ile giriş yapanlar erişebilir
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    
    # 'Assignment' modelindeki (yani 'staff_room_history') doğru alan adları
    filterset_fields = ['faculty', 'office', 'start_date', 'end_date']
    search_fields = ['faculty__full_name', 'office__room_number', 'notes']
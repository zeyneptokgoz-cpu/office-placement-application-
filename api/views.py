# api/views.py
from rest_framework import viewsets, filters, permissions
from django_filters.rest_framework import DjangoFilterBackend

from .models import (
    Building, Department, Faculty, Office, Assignment
)
from .serializers import (
    BuildingSerializer, DepartmentSerializer, FacultySerializer, 
    OfficeSerializer, AssignmentSerializer
)

# --- Özel İzin Sınıfı ---
# Proje gereksinimlerine göre (Admin günceller, herkes arar)
# en uygun izin yapısı budur.

class IsAdminOrReadOnly(permissions.BasePermission):
    """
    Bu izin sınıfı, herkesin (oturum açmamış kullanıcılar dahil)
    veriyi GÖRÜNTÜLEMESİNE (GET isteği) izin verir,
    ancak sadece 'admin' (is_staff=True) kullanıcıların
    veri OLUŞTURMASINA, GÜNCELLEMESİNE veya SİLMESİNE
    (POST, PUT, PATCH, DELETE) izin verir.
    """
    def has_permission(self, request, view):
        # GET, HEAD, OPTIONS gibi "güvenli" (salt okunur) metotlar herkese açıktır.
        if request.method in permissions.SAFE_METHODS:
            return True
        
        # Yazma (POST, PUT, DELETE) izinleri sadece admin kullanıcılara verilir.
        return request.user and request.user.is_staff

# --- API ViewSet'leri ---
# ModelViewSet, bizim için otomatik olarak 5 tane endpoint sağlar:
# list()    -> GET /api/model/     (Tümünü listeler)
# create()  -> POST /api/model/    (Yeni oluşturur)
# retrieve() -> GET /api/model/1/   (Tek bir tanesini getirir)
# update()  -> PUT /api/model/1/   (Günceller)
# destroy() -> DELETE /api/model/1/ (Siler)

class BuildingViewSet(viewsets.ModelViewSet):
    """Binaları listelemek ve yönetmek için API endpoint'i."""
    queryset = Building.objects.all()
    serializer_class = BuildingSerializer
    permission_classes = [IsAdminOrReadOnly] # Yetki: Sadece adminler düzenleyebilir


class DepartmentViewSet(viewsets.ModelViewSet):
    """Departmanları listelemek ve yönetmek için API endpoint'i."""
    queryset = Department.objects.all().order_by('name')
    serializer_class = DepartmentSerializer
    permission_classes = [IsAdminOrReadOnly]
    filter_backends = [filters.SearchFilter] # Arama filtresini ekle
    search_fields = ['name'] # 'name' alanına göre arama yap


class FacultyViewSet(viewsets.ModelViewSet):
    """Personelleri listelemek ve yönetmek için API endpoint'i."""
    queryset = Faculty.objects.select_related('department').all() # Veritabanı optimizasyonu
    serializer_class = FacultySerializer
    permission_classes = [IsAdminOrReadOnly]
    
    # Proje gereksinimi: Departman, occupant (personel) veya ofis no'ya göre arama/filtreleme
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['department'] # /api/faculty/?department=5 gibi filtrelemeye izin ver
    search_fields = ['full_name', 'email', 'staff_id', 'department__name']


class OfficeViewSet(viewsets.ModelViewSet):
    """Ofisleri listelemek ve yönetmek için API endpoint'i."""
    
    # prefetch_related ve select_related:
    # Bu, 'N+1' sorgu problemini çözer. Bir ofisi çekerken
    # ilişkili olduğu bina, departman ve atama bilgilerini
    # tek bir veritabanı sorgusunda getirir. Performans için kritiktir.
    queryset = Office.objects.prefetch_related(
        'departments', 
        'assignments', 
        'assignments__faculty'
    ).select_related('building').all()
    
    serializer_class = OfficeSerializer
    permission_classes = [IsAdminOrReadOnly]
    
    # Proje gereksinimi: Gelişmiş arama ve filtreleme
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    
    # /api/offices/?floor=2&capacity=4&building=1 gibi filtrelemeye izin ver
    filterset_fields = ['building', 'floor', 'capacity', 'departments']
    
    # Kullanıcının metin kutusuna yazarak arama yapacağı alanlar
    search_fields = [
        'office_number', 
        'building__name', 
        'building__code', 
        'departments__name',
        'assignments__faculty__full_name' # Ofis içindeki personelin adına göre ara
    ]


class AssignmentViewSet(viewsets.ModelViewSet):
    """Yerleşim/Atama kayıtlarını listelemek ve yönetmek için API endpoint'i."""
    
    queryset = Assignment.objects.select_related(
        'faculty', 
        'office', 
        'office__building' # Atamanın ofisinin binasını da getir
    ).all()
    
    serializer_class = AssignmentSerializer
    permission_classes = [IsAdminOrReadOnly] # Sadece adminler atama yapabilir/değiştirebilir
    
    # /api/assignments/?faculty=10&office=2&end_date__isnull=true (aktif olanlar)
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['faculty', 'office', 'end_date']
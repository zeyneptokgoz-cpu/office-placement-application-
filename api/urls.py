# api/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

# SimpleJWT'nin GİRİŞ ve YENİLEME görünümlerini import ediyoruz
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

# --- YENİ VIEW'İ (RegisterView) IMPORT EDİYORUZ ---
# (views.'dan RegisterView'i de alıyoruz)
from .views import RegisterView


# --- Router Ayarları (Mevcut kodunuz) ---
# DefaultRouter, ViewSet'lerimiz için tüm URL'leri otomatik olarak oluşturur.
router = DefaultRouter()
router.register(r'buildings', views.BuildingViewSet, basename='building')
router.register(r'departments', views.DepartmentViewSet, basename='department')
router.register(r'faculty', views.FacultyViewSet, basename='faculty')
router.register(r'offices', views.OfficeViewSet, basename='office')
router.register(r'assignments', views.AssignmentViewSet, basename='assignment')
# --- Router Ayarları Bitişi ---


# API URL'lerimiz router tarafından oluşturulanları VE manuel eklediklerimizi içerir.
urlpatterns = [
    # 1. Router tarafından otomatik oluşturulan URL'ler
    # (api/buildings/, api/offices/ vb.)
    path('', include(router.urls)),
    
    # 2. Manuel olarak eklenen Kimlik Doğrulama URL'leri
    
    # Giriş (Token alma) adresi: api/token/
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    
    # Token yenileme adresi: api/token/refresh/
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # --- 3. YENİ KAYIT (SIGN-UP) URL'İ ---
    path('register/', RegisterView.as_view(), name='register'),
]
# api/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

# DefaultRouter, ViewSet'lerimiz için tüm URL'leri otomatik olarak oluşturur.
# Örn: /offices/ -> (GET) Listele, (POST) Oluştur
# Örn: /offices/1/ -> (GET) Detay, (PUT) Güncelle, (DELETE) Sil
router = DefaultRouter()
router.register(r'buildings', views.BuildingViewSet, basename='building')
router.register(r'departments', views.DepartmentViewSet, basename='department')
router.register(r'faculty', views.FacultyViewSet, basename='faculty')
router.register(r'offices', views.OfficeViewSet, basename='office')
router.register(r'assignments', views.AssignmentViewSet, basename='assignment')

# API URL'lerimiz router tarafından oluşturulanları içerir.
urlpatterns = [
    path('', include(router.urls)),
]
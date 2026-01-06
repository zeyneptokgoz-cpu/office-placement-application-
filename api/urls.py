from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from . import views

# Public router (Read-only for regular users)
router = DefaultRouter()
router.register(r'buildings', views.BuildingViewSet, basename='building')
router.register(r'departments', views.DepartmentViewSet, basename='department')
router.register(r'faculty', views.FacultyViewSet, basename='faculty')
router.register(r'offices', views.OfficeViewSet, basename='office')
router.register(r'assignments', views.AssignmentViewSet, basename='assignment')

# Admin router (Full CRUD for admins)
admin_router = DefaultRouter()
admin_router.register(r'buildings', views.AdminBuildingViewSet, basename='admin-building')
admin_router.register(r'departments', views.AdminDepartmentViewSet, basename='admin-department')
admin_router.register(r'faculty', views.AdminFacultyViewSet, basename='admin-faculty')
admin_router.register(r'offices', views.AdminOfficeViewSet, basename='admin-office')
admin_router.register(r'assignments', views.AdminAssignmentViewSet, basename='admin-assignment')

urlpatterns = [
    # Authentication
    path('sign-up/', views.SignUpView.as_view(), name='sign_up'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # Public API (Read-only)
    path('', include(router.urls)),
    
    # Admin API (Full CRUD)
    path('admin/', include(admin_router.urls)),
]
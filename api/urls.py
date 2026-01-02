from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from . import views

router = DefaultRouter()
router.register(r'buildings', views.BuildingViewSet, basename='building')
router.register(r'departments', views.DepartmentViewSet, basename='department')
router.register(r'faculty', views.FacultyViewSet, basename='faculty')
router.register(r'offices', views.OfficeViewSet, basename='office')
router.register(r'assignments', views.AssignmentViewSet, basename='assignment')

urlpatterns = [
    path('', include(router.urls)),
    path('sign-up/', views.SignUpView.as_view(), name='sign_up'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
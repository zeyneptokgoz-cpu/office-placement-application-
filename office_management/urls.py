# office_management/urls.py
from django.contrib import admin
from django.urls import path, include  # <-- 'include' fonksiyonunu buraya import edin

urlpatterns = [
    path('admin/', admin.site.urls),
    
    # ---- YENİ SATIR ----
    # "site.com/api/" ile başlayan tüm istekleri
    # api/urls.py dosyamıza yönlendirir.
    path('api/', include('api.urls')),
    # --------------------
]
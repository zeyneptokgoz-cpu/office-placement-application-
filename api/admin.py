# api/admin.py
from django.contrib import admin
from .models import (
    FacultyDivision, 
    Title, 
    Building, 
    Floor, 
    Department, 
    Faculty, 
    Office, 
    Assignment
)

# Hata ayıklaması: Eski, hatalı admin sınıfları yerine 
# tüm modelleri varsayılan admin arayüzü ile kaydediyoruz.
# Bu, 'runserver' komutunun çalışmasını garantiler.

# Admin panelinde 'FacultyDivision' modelini göster
admin.site.register(FacultyDivision)

# Admin panelinde 'Title' modelini göster
admin.site.register(Title)

# Admin panelinde 'Building' modelini göster
admin.site.register(Building)

# Admin panelinde 'Floor' modelini göster
admin.site.register(Floor)

# Admin panelinde 'Department' modelini göster
admin.site.register(Department)

# Admin panelinde 'Faculty' (Personel) modelini göster
admin.site.register(Faculty)

# Admin panelinde 'Office' (Odalar) modelini göster
admin.site.register(Office)

# Admin panelinde 'Assignment' (Yerleşimler) modelini göster
admin.site.register(Assignment)
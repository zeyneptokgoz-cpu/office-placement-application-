# api/models.py
from django.db import models
from django.core.exceptions import ValidationError
from django.utils import timezone

# Model 1: Building (Bina)
# "AS - 111"deki "AS" kısmını tutar.
class Building(models.Model):
    name = models.CharField(max_length=255, help_text="Bina tam adı (Örn: Mühendislik Fakültesi A Binası)")
    code = models.CharField(max_length=10, unique=True, help_text="Bina kısa kodu (Örn: AS)")

    def __str__(self):
        return self.name

# Model 2: Department (Departman)
# "Faculty of Engineering" gibi departmanları tutar.
class Department(models.Model):
    name = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.name

# Model 3: Faculty (Personel)
# "Personnel List" içindeki "Asst. Prof. Dr. Nigar NAGİYEVA" gibi her bir kişiyi temsil eder.
class Faculty(models.Model):
    title = models.CharField(max_length=50, blank=True, help_text="Örn: Asst. Prof. Dr.")
    full_name = models.CharField(max_length=255)
    email = models.EmailField(unique=True, null=True, blank=True)
    staff_id = models.CharField(max_length=100, unique=True, null=True, blank=True, help_text="Personel sicil numarası")
    department = models.ForeignKey(Department, on_delete=models.SET_NULL, null=True, blank=True, related_name="staff")

    class Meta:
        verbose_name_plural = "Faculty" # Admin panelinde "Facultys" yerine "Faculty" yazar

    def __str__(self):
        return f"{self.title} {self.full_name}"

# Model 4: Office (Ofis)
# CSV'deki her bir satırı (odayı) temsil eder.
class Office(models.Model):
    office_number = models.CharField(max_length=50, help_text="Örn: 111")
    building = models.ForeignKey(Building, on_delete=models.CASCADE, related_name="offices")
    floor = models.IntegerField()
    capacity = models.PositiveIntegerField(default=1, help_text="Oda kapasitesi (Room Capacity (People))")
    
    # CSV'den gelen ekstra envanter verileri
    num_desks = models.PositiveIntegerField(default=0, help_text="Number of Desks")
    num_chairs = models.PositiveIntegerField(default=0, help_text="Number of Chairs")
    num_cabinets = models.PositiveIntegerField(default=0, help_text="Number of Cabinets")
    
    # Bir ofis birden fazla departmana ait olabilir (Veri setinde '&' ile ayrılanlar vardı)
    departments = models.ManyToManyField(Department, blank=True, related_name="offices")

    def __str__(self):
        return f"{self.building.code} - {self.office_number}"

    # Bu 'property' sayesinde bir ofiste *şu an* kaç kişi olduğunu dinamik olarak hesaplarız.
    @property
    def current_occupancy(self):
        """Ofiste şu an (end_date'i olmayan) kaç kişi olduğunu döndürür."""
        return self.assignments.filter(end_date__isnull=True).count()

    # Kapasite kontrolü için bir property
    @property
    def is_over_capacity(self):
        """Mevcut kişi sayısı kapasiteyi aştıysa True döndürür."""
        return self.current_occupancy > self.capacity

# Model 5: Assignment (Yerleşim/Atama) - PROJENİN KALBİ
# Hangi personelin (Faculty) hangi ofiste (Office) hangi tarihler arasında kaldığını tutar.
class Assignment(models.Model):
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE, related_name="assignments")
    office = models.ForeignKey(Office, on_delete=models.CASCADE, related_name="assignments")
    start_date = models.DateField(default=timezone.now)
    end_date = models.DateField(null=True, blank=True, help_text="Eğer personel hala bu ofisteyse bu alan boş olmalıdır.")

    class Meta:
        # Bir personelin aynı anda birden fazla aktif görevi olmasın
        unique_together = ('faculty', 'end_date')

    def __str__(self):
        status = " (Aktif)" if self.end_date is None else f" (Ayrıldı: {self.end_date})"
        return f"{self.faculty.full_name} -> {self.office} {status}"

    # Yeni atama yapılırken kapasite kontrolü burada yapılacak
    def clean(self):
        # Sadece yeni bir atama yapılıyorsa veya aktif bir atama değiştiriliyorsa kontrol et
        if self.end_date is None:
            # Bu kişi hariç, ofisteki diğer aktif kişilerin sayısı
            current_occupants = self.office.assignments.filter(end_date__isnull=True).exclude(pk=self.pk).count()
            
            if current_occupants >= self.office.capacity:
                raise ValidationError(
                    f"Kapasite Aşıldı! '{self.office}' odasının kapasitesi ({self.office.capacity}) "
                    f"ve zaten {current_occupants} kişi bulunuyor."
                )

    def save(self, *args, **kwargs):
        self.clean() # Kaydetmeden önce 'clean' metodunu çağırarak kontrol yap
        super().save(*args, **kwargs)
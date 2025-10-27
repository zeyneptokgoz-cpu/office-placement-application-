# api/serializers.py
from rest_framework import serializers
from .models import Building, Department, Faculty, Office, Assignment

# --- Basit Modeller İçin Serializer'lar ---
# Bu serializer'lar genellikle başka serializer'ların içine gömülür.

class BuildingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Building
        fields = ['id', 'name', 'code']


class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = ['id', 'name']

# --- Ana Modeller İçin Serializer'lar ---

class FacultySerializer(serializers.ModelSerializer):
    """
    Personel (Faculty) modeli için tam detaylı serializer.
    Okuma (GET) için departman adını da ('department_name') gösterir.
    Yazma (POST) için sadece departman ID'sini ('department') alır.
    """
    department_name = serializers.CharField(source='department.name', read_only=True)

    class Meta:
        model = Faculty
        fields = [
            'id', 'title', 'full_name', 'email', 'staff_id', 
            'department', 'department_name'
        ]
        # 'department' alanı varsayılan olarak PrimaryKeyRelatedField'dir
        # Bu sayede POST isteğinde 'department: 5' gibi bir ID göndermek yeterlidir.


class AssignmentForOfficeSerializer(serializers.ModelSerializer):
    """
    Bu, Ofis detayında "içeride kim var?" sorusuna cevap vermek için 
    kullanılan YARDIMCI bir serializer'dır.
    Sadece personel bilgilerini ve başlangıç tarihini gösterir.
    (Eğer 'AssignmentSerializer'ı burada kullansaydık,
    döngüsel bir hataya neden olurdu.)
    """
    # 'faculty' alanı için tam obje yerine sadece isim vb. göstermek için
    # basit bir FacultySerializer da yapılabilir, ama şimdilik bu yeterli.
    faculty_name = serializers.CharField(source='faculty.full_name', read_only=True)
    faculty_title = serializers.CharField(source='faculty.title', read_only=True)
    
    class Meta:
        model = Assignment
        fields = ['id', 'faculty', 'faculty_title', 'faculty_name', 'start_date']


class OfficeSerializer(serializers.ModelSerializer):
    """
    Projedeki en önemli serializer'lardan biri.
    Bir ofisin TÜM detaylarını, içindeki departmanları ve 
    mevcut personelleri gösterir.
    """
    # İlişkili Bina modelinden 'code' alanını getir (read_only)
    building_code = serializers.CharField(source='building.code', read_only=True)
    
    # İlişkili Departmanları (M2M) tam obje olarak getir (read_only)
    departments_detail = DepartmentSerializer(many=True, read_only=True, source='departments')
    
    # Model'den gelen @property'leri (hesaplanan alanlar) ekle
    current_occupancy = serializers.IntegerField(read_only=True)
    is_over_capacity = serializers.BooleanField(read_only=True)
    
    # Ofiste *şu an* aktif olan personelleri getir (read_only)
    active_assignments = serializers.SerializerMethodField()

    class Meta:
        model = Office
        fields = [
            'id', 'office_number', 'building', 'building_code', 'floor', 'capacity',
            'num_desks', 'num_chairs', 'num_cabinets',
            'current_occupancy', 'is_over_capacity', 
            'departments',        # YAZMA (POST/PUT) için (ID listesi alır: [1, 2])
            'departments_detail', # OKUMA (GET) için (Obje listesi döner)
            'active_assignments'  # OKUMA (GET) için (Obje listesi döner)
        ]
        extra_kwargs = {
            # 'departments' alanı sadece yazma için kullanılsın, 
            # okurken 'departments_detail' kullanılacak.
            'departments': {'write_only': True} 
        }

    def get_active_assignments(self, obj):
        """
        SerializerMethodField'i doldurur.
        Sadece 'end_date' alanı boş (NULL) olan, yani aktif personelleri bulur.
        """
        active_assignments = obj.assignments.filter(end_date__isnull=True)
        # Onları yardımcı serializer ile JSON'a çevirir
        serializer = AssignmentForOfficeSerializer(active_assignments, many=True, context=self.context)
        return serializer.data


class AssignmentSerializer(serializers.ModelSerializer):
    """
    Yerleşim (Assignment) modeli için tam detaylı serializer.
    /api/assignments/ gibi sayfalarda listeleme için kullanılır.
    Okuma için personel ve ofis isimlerini de gösterir.
    """
    faculty_name = serializers.CharField(source='faculty.full_name', read_only=True)
    office_name = serializers.CharField(source='office.__str__', read_only=True)

    class Meta:
        model = Assignment
        fields = [
            'id', 
            'faculty', 'faculty_name', 
            'office', 'office_name', 
            'start_date', 'end_date'
        ]
        
    def validate(self, data):
        """
        Kapasite kontrolünü 'models.py' yerine burada da yapabiliriz.
        Modeldeki 'clean' metodu zaten bunu yapıyor, ancak DRF'in kendi
        validation mekanizmasını kullanmak daha standarttır.
        (Modeldeki 'clean' metodunu bu durumda kaldırabiliriz)
        """
        office = data.get('office')
        end_date = data.get('end_date')

        # Sadece yeni bir aktif atama yapılırken kontrol et
        if office and end_date is None:
            # Mevcut aktif atamaların sayısı
            current_occupancy = office.assignments.filter(end_date__isnull=True).count()
            if current_occupancy >= office.capacity:
                raise serializers.ValidationError(
                    f"Kapasite Aşıldı! '{office}' odasının kapasitesi ({office.capacity}) "
                    f"ve zaten {current_occupancy} kişi bulunuyor."
                )
        return data
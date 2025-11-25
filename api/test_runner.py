# api/test_runner.py
from django.test.runner import DiscoverRunner
from django.apps import apps

class ForceManagedModelTestRunner(DiscoverRunner):
    """
    Testler çalışırken:
    1. Migration dosyalarını görmezden gelir (Settings ayarı ile birlikte).
    2. 'managed=False' olan modelleri 'managed=True' yapar.
    Böylece test veritabanında tablolar sıfırdan oluşturulur.
    """
    def setup_test_environment(self, *args, **kwargs):
        # Tüm modelleri bul ve managed=True yap
        self.unmanaged_models = [
            m for m in apps.get_models() if not m._meta.managed
        ]
        for m in self.unmanaged_models:
            m._meta.managed = True
        super().setup_test_environment(*args, **kwargs)

    def teardown_test_environment(self, *args, **kwargs):
        super().teardown_test_environment(*args, **kwargs)
        # Test bitince her şeyi eski haline (managed=False) getir
        for m in self.unmanaged_models:
            m._meta.managed = False
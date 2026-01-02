from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.views import APIView

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView


def get_role(user) -> str:
    groups = set(user.groups.values_list("name", flat=True))
    if user.is_superuser:
        return "admin"
    if "teacher" in groups:
        return "teacher"
    if "student" in groups:
        return "student"
    return "unknown"


class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token["role"] = get_role(user)
        token["username"] = user.username
        return token


class MyTokenObtainPairView(TokenObtainPairView):
    permission_classes = [AllowAny]
    serializer_class = MyTokenObtainPairSerializer


class MeView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        u = request.user
        return Response({
            "username": u.username,
            "first_name": u.first_name,
            "last_name": u.last_name,
            "role": get_role(u),
        })

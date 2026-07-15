from rest_framework import generics
from apps.accounts.serializers import UnitSerializer, MeSerializer


class UnitListView(generics.ListAPIView):
    serializer_class = UnitSerializer

    def get_queryset(self):
        return self.request.user.units.all()


class MeView(generics.RetrieveAPIView):
    serializer_class = MeSerializer

    def get_object(self):
        return self.request.user

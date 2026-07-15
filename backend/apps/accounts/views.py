from rest_framework import generics
from apps.accounts.serializers import UnitSerializer


class UnitListView(generics.ListAPIView):
    serializer_class = UnitSerializer

    def get_queryset(self):
        return self.request.user.units.all()

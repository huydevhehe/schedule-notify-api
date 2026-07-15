from rest_framework import generics
from apps.meetings.models import Meeting
from apps.meetings.serializers import MeetingSerializer
from apps.meetings.permissions import IsUnitAdminForWrite


class MeetingListCreateView(generics.ListCreateAPIView):
    serializer_class = MeetingSerializer
    permission_classes = [IsUnitAdminForWrite]

    def get_queryset(self):
        queryset = Meeting.objects.filter(unit__in=self.request.user.units.all())
        unit_id = self.request.query_params.get("unit")
        if unit_id:
            queryset = queryset.filter(unit_id=unit_id)
        return queryset

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class MeetingDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = MeetingSerializer
    permission_classes = [IsUnitAdminForWrite]

    def get_queryset(self):
        return Meeting.objects.filter(unit__in=self.request.user.units.all())

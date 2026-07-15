from rest_framework import serializers
from apps.meetings.models import Meeting


class MeetingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Meeting
        fields = [
            "id", "title", "start_time", "end_time", "host", "preparation",
            "participants", "location", "note", "is_important", "unit",
            "created_by", "created_at",
        ]
        read_only_fields = ["created_by", "created_at"]

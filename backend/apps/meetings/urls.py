from django.urls import path
from apps.meetings.views import MeetingListCreateView

urlpatterns = [
    path("", MeetingListCreateView.as_view(), name="meeting-list-create"),
]

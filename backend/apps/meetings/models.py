from django.conf import settings
from django.db import models
from apps.accounts.models import Unit


class Meeting(models.Model):
    title = models.CharField(max_length=255)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    host = models.CharField(max_length=255, blank=True, default="")
    preparation = models.CharField(max_length=255, blank=True, default="")
    participants = models.TextField(blank=True, default="")
    location = models.CharField(max_length=255)
    note = models.TextField(blank=True, default="")
    is_important = models.BooleanField(default=False)
    unit = models.ForeignKey(Unit, related_name="meetings", on_delete=models.CASCADE)
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, related_name="created_meetings", on_delete=models.CASCADE
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["start_time"]

    def __str__(self):
        return self.title

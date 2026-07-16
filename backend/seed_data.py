import django
import os

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
django.setup()

from apps.accounts.models import Unit, User
from apps.meetings.models import Meeting
from django.utils import timezone
import datetime

unit, _ = Unit.objects.get_or_create(code="VTTP", defaults={"name": "VTTP"})
admin = User.objects.get(username="admin")
admin.units.add(unit)

if not Meeting.objects.filter(unit=unit).exists():
    start = timezone.now().replace(hour=9, minute=0, second=0, microsecond=0)
    Meeting.objects.create(
        title="Hop ra soat tien do du an",
        start_time=start,
        end_time=start + datetime.timedelta(hours=1),
        host="B. Trinh Thi Thu Thao",
        preparation="TTKD",
        participants="Phong KT, Phong KD",
        location="Phong hop so 3",
        note="",
        is_important=True,
        unit=unit,
        created_by=admin,
    )
    print("created sample meeting")
else:
    print("meeting already exists")

print("Users:", list(User.objects.values_list("username", flat=True)))
print("Units:", list(Unit.objects.values_list("code", flat=True)))
print("Meetings:", list(Meeting.objects.values_list("title", flat=True)))

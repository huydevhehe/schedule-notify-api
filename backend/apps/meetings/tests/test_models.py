from django.test import TestCase
from django.utils import timezone
from apps.accounts.models import Unit, User
from apps.meetings.models import Meeting


class MeetingModelTest(TestCase):
    def setUp(self):
        self.unit = Unit.objects.create(name="VTTP", code="VTTP")
        self.admin = User.objects.create_user(username="thao", password="pass1234")

    def test_str_returns_title(self):
        meeting = Meeting.objects.create(
            title="Họp rà soát tiến độ",
            start_time=timezone.now(),
            end_time=timezone.now() + timezone.timedelta(hours=1),
            location="Phòng họp số 3",
            unit=self.unit,
            created_by=self.admin,
        )
        self.assertEqual(str(meeting), "Họp rà soát tiến độ")

    def test_defaults(self):
        meeting = Meeting.objects.create(
            title="Họp thường kỳ",
            start_time=timezone.now(),
            end_time=timezone.now() + timezone.timedelta(hours=1),
            location="Online",
            unit=self.unit,
            created_by=self.admin,
        )
        self.assertFalse(meeting.is_important)
        self.assertEqual(meeting.host, "")

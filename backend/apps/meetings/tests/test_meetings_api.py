from django.urls import reverse
from django.utils import timezone
from rest_framework.test import APITestCase
from rest_framework import status
from apps.accounts.models import Unit, User
from apps.meetings.models import Meeting


class MeetingListCreateApiTest(APITestCase):
    def setUp(self):
        self.vttp = Unit.objects.create(name="VTTP", code="VTTP")
        self.other_unit = Unit.objects.create(name="VNPT Nam Sài Gòn", code="VNPT_NSG")

        self.admin = User.objects.create_user(
            username="thao", password="pass1234", role=User.Role.ADMIN
        )
        self.admin.units.add(self.vttp)

        self.employee = User.objects.create_user(
            username="nhan_vien", password="pass1234", role=User.Role.EMPLOYEE
        )
        self.employee.units.add(self.vttp)

        self.start = timezone.now()
        self.end = self.start + timezone.timedelta(hours=1)

        Meeting.objects.create(
            title="Họp VTTP", start_time=self.start, end_time=self.end,
            location="Online", unit=self.vttp, created_by=self.admin,
        )
        Meeting.objects.create(
            title="Họp đơn vị khác", start_time=self.start, end_time=self.end,
            location="Online", unit=self.other_unit, created_by=self.admin,
        )

    def test_requires_authentication(self):
        response = self.client.get(reverse("meeting-list-create"))
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_list_filters_by_unit_query_param(self):
        self.client.force_authenticate(user=self.employee)
        response = self.client.get(reverse("meeting-list-create"), {"unit": self.vttp.id})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]["title"], "Họp VTTP")

    def test_employee_cannot_create_meeting(self):
        self.client.force_authenticate(user=self.employee)
        payload = {
            "title": "Họp mới", "start_time": self.start, "end_time": self.end,
            "location": "Online", "unit": self.vttp.id,
        }
        response = self.client.post(reverse("meeting-list-create"), payload, format="json")
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_admin_can_create_meeting_for_own_unit(self):
        self.client.force_authenticate(user=self.admin)
        payload = {
            "title": "Họp mới", "start_time": self.start, "end_time": self.end,
            "location": "Online", "unit": self.vttp.id,
        }
        response = self.client.post(reverse("meeting-list-create"), payload, format="json")
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Meeting.objects.filter(unit=self.vttp).count(), 2)

    def test_admin_cannot_create_meeting_for_other_unit(self):
        self.client.force_authenticate(user=self.admin)
        payload = {
            "title": "Họp mới", "start_time": self.start, "end_time": self.end,
            "location": "Online", "unit": self.other_unit.id,
        }
        response = self.client.post(reverse("meeting-list-create"), payload, format="json")
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)


class MeetingDetailApiTest(APITestCase):
    def setUp(self):
        self.vttp = Unit.objects.create(name="VTTP", code="VTTP")
        self.admin = User.objects.create_user(
            username="thao", password="pass1234", role=User.Role.ADMIN
        )
        self.admin.units.add(self.vttp)
        self.employee = User.objects.create_user(
            username="nhan_vien", password="pass1234", role=User.Role.EMPLOYEE
        )
        self.employee.units.add(self.vttp)

        start = timezone.now()
        end = start + timezone.timedelta(hours=1)
        self.meeting = Meeting.objects.create(
            title="Họp VTTP", start_time=start, end_time=end,
            location="Online", unit=self.vttp, created_by=self.admin,
        )

    def test_employee_can_read_detail(self):
        self.client.force_authenticate(user=self.employee)
        response = self.client.get(reverse("meeting-detail", args=[self.meeting.id]))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["title"], "Họp VTTP")

    def test_employee_cannot_update(self):
        self.client.force_authenticate(user=self.employee)
        response = self.client.patch(
            reverse("meeting-detail", args=[self.meeting.id]),
            {"title": "Đổi tên"}, format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_admin_can_update(self):
        self.client.force_authenticate(user=self.admin)
        response = self.client.patch(
            reverse("meeting-detail", args=[self.meeting.id]),
            {"title": "Đổi tên"}, format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.meeting.refresh_from_db()
        self.assertEqual(self.meeting.title, "Đổi tên")

    def test_admin_can_delete(self):
        self.client.force_authenticate(user=self.admin)
        response = self.client.delete(reverse("meeting-detail", args=[self.meeting.id]))
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Meeting.objects.filter(id=self.meeting.id).exists())

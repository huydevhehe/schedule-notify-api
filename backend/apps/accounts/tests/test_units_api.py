from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from apps.accounts.models import Unit, User


class UnitListApiTest(APITestCase):
    def setUp(self):
        self.vttp = Unit.objects.create(name="VTTP", code="VTTP")
        Unit.objects.create(name="VNPT Nam Sài Gòn", code="VNPT_NSG")
        self.user = User.objects.create_user(username="thao", password="pass1234")
        self.user.units.add(self.vttp)

    def test_requires_authentication(self):
        response = self.client.get(reverse("unit-list"))
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_returns_only_users_units(self):
        self.client.force_authenticate(user=self.user)
        response = self.client.get(reverse("unit-list"))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]["code"], "VTTP")

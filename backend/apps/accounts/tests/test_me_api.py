from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from apps.accounts.models import Unit, User


class MeApiTest(APITestCase):
    def setUp(self):
        self.vttp = Unit.objects.create(name="VTTP", code="VTTP")
        self.admin = User.objects.create_user(
            username="thao", password="pass1234", role=User.Role.ADMIN
        )
        self.admin.units.add(self.vttp)

    def test_requires_authentication(self):
        response = self.client.get(reverse("me"))
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_returns_current_user_role_and_units(self):
        self.client.force_authenticate(user=self.admin)
        response = self.client.get(reverse("me"))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["username"], "thao")
        self.assertEqual(response.data["role"], "admin")
        self.assertEqual(len(response.data["units"]), 1)
        self.assertEqual(response.data["units"][0]["code"], "VTTP")

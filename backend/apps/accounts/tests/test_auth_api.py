from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from apps.accounts.models import User


class LoginApiTest(APITestCase):
    def setUp(self):
        User.objects.create_user(username="thao", password="pass1234")

    def test_login_with_valid_credentials_returns_tokens(self):
        url = reverse("token_obtain_pair")
        response = self.client.post(
            url, {"username": "thao", "password": "pass1234"}, format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("access", response.data)
        self.assertIn("refresh", response.data)

    def test_login_with_invalid_credentials_returns_401(self):
        url = reverse("token_obtain_pair")
        response = self.client.post(
            url, {"username": "thao", "password": "wrong"}, format="json"
        )
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

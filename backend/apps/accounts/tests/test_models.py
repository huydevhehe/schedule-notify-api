from django.test import TestCase
from apps.accounts.models import Unit, User


class UnitModelTest(TestCase):
    def test_str_returns_name(self):
        unit = Unit.objects.create(name="VTTP", code="VTTP")
        self.assertEqual(str(unit), "VTTP")


class UserModelTest(TestCase):
    def test_user_has_role_and_units(self):
        unit = Unit.objects.create(name="VTTP", code="VTTP")
        user = User.objects.create_user(
            username="thao", password="pass1234", role=User.Role.ADMIN
        )
        user.units.add(unit)

        self.assertEqual(user.role, User.Role.ADMIN)
        self.assertIn(unit, user.units.all())

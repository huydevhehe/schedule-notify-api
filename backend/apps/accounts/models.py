from django.contrib.auth.models import AbstractUser
from django.db import models


class Unit(models.Model):
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=30, unique=True)

    def __str__(self):
        return self.name


class User(AbstractUser):
    class Role(models.TextChoices):
        ADMIN = "admin", "Admin"
        EMPLOYEE = "employee", "Employee"

    role = models.CharField(max_length=20, choices=Role.choices, default=Role.EMPLOYEE)
    units = models.ManyToManyField(Unit, related_name="users", blank=True)

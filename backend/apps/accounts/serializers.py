from rest_framework import serializers
from apps.accounts.models import Unit, User


class UnitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Unit
        fields = ["id", "name", "code"]


class MeSerializer(serializers.ModelSerializer):
    units = UnitSerializer(many=True, read_only=True)

    class Meta:
        model = User
        fields = ["id", "username", "role", "units"]

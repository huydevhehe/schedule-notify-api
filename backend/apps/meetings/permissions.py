from rest_framework.permissions import BasePermission
from apps.accounts.models import User


class IsUnitAdminForWrite(BasePermission):
    """Allows read to any authenticated user; write only to admins of the target unit."""

    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if request.method in ("GET", "HEAD", "OPTIONS"):
            return True
        if user.role != User.Role.ADMIN:
            return False
        unit_id = request.data.get("unit")
        if unit_id is not None:
            return user.units.filter(id=unit_id).exists()
        return True  # object-level check in has_object_permission covers PATCH/DELETE

    def has_object_permission(self, request, view, obj):
        if request.method in ("GET", "HEAD", "OPTIONS"):
            return True
        user = request.user
        return user.role == User.Role.ADMIN and user.units.filter(id=obj.unit_id).exists()

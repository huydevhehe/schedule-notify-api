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
        return user.units.filter(id=unit_id).exists()

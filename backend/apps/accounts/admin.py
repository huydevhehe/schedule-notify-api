from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from apps.accounts.models import Unit, User

admin.site.register(Unit)
admin.site.register(User, UserAdmin)

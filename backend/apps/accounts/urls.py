from django.urls import path
from apps.accounts.views import UnitListView

urlpatterns = [
    path("", UnitListView.as_view(), name="unit-list"),
]

from django.urls import path

from . import views

urlpatterns = [
    path('b/<str:identifier>/', views.beat, name='beat'),
    path('g/<str:identifier>/', views.graph, name='graph'),
    path('s/<str:identifier>/', views.status, name='status'),
]

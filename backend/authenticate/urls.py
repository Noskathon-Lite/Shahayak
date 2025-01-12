from django.urls import path,include
from .views import *
urlpatterns = [
    path('login/', UserLoginView.as_view(), name='login' ),
    path('register/', UserRegistrationView.as_view(), name='register'),
    path('profile/',ProfileDetailView.as_view(), name='profile'),
    path('verify/', VerifyOTP.as_view(), name='verify')
]


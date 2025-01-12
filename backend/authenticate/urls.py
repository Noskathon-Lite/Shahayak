from django.urls import path,include
from .views import *
urlpatterns = [
    path('login/', UserLoginView.as_view(), name='login' ),
    path('register/', UserRegistrationView.as_view(), name='register')
]
>>>>>>> 853366b6b02d561b9c737aec69431be4c859b882

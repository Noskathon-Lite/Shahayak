

urlpatterns= [
    path('register/', UserRegistrationView.as_view(), name='reguster'),

   

]


from django.urls import path,include
from .views import *
urlpatterns = [
    path('login/', UserLoginView.as_view(), name='login' ),
]


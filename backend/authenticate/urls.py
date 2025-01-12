<<<<<<< HEAD


urlpatterns= [
    path('register/', UserRegistrationView.as_view(), name='reguster'),

   

]


=======
>>>>>>> 6269349d53518f30fad4bffa16e18e5b0fc9c6fd
from django.urls import path,include
from .views import *
urlpatterns = [
    path('login/', UserLoginView.as_view(), name='login' ),
    path('register/', UserRegistrationView.as_view(), name='register')
]


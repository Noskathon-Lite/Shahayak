from django.urls import path,include
from .views import *
urlpatterns = [
    path('product_list/', ProductListView.as_view(),name = 'ProductList')
]


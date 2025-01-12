from django.urls import path,include
from .views import *
urlpatterns = [
    path('product_list/', ProductListView.as_view(),name = 'ProductList'),
    path('product_detail/<int:pk>', Product_DetailsView.as_view(),name = 'Product_Details'),
]


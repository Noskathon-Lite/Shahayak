from django.urls import path,include
from .views import *
urlpatterns = [
    path('product_list/', ProductListView.as_view(),name = 'ProductList'),
    path('product_detail/<int:pk>', Product_DetailsView.as_view(),name = 'Product_Details'),
    path('comment_list/', CommentListView.as_view(),name = 'CommentList'),
    path('comment_update/<int:pk>', CommentUpdateView.as_view(), name='Comment_Update'),
    path('products/<int:pk>/like/', LikeToggleView.as_view(), name='like-toggle'),

]


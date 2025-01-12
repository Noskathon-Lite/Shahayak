from rest_framework import serializers
from .models import Product

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['user','product_name', 'category', 'image', 'price', 'purchase_date','product_condition','caption']
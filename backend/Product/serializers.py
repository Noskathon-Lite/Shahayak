from rest_framework import serializers
from .models import Product
from authenticate.models import Comment

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id','user','product_name', 'category','type', 'image', 'price', 'purchase_date','product_condition','caption']

class CommentSerializer(serializers.ModelSerializer):
    product_id = serializers.PrimaryKeyRelatedField(
        queryset=Product.objects.all(),
        source='product'  # Map to the 'product' field in the Comment model
    )

    class Meta:
        model = Comment
        fields = ['product_id', 'comment_text']  # Include 'product_id' in the fields
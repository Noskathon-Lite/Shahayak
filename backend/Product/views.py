from django.shortcuts import render
from .serializers import *
from rest_framework import generics
from rest_framework.views import APIView
from .models import Product
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
from .filters import ProductFilter
from rest_framework.generics import ListAPIView


# Create your views here.



class ProductListView(ListAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    filterset_class = ProductFilter
    search_fields = ['product_name']

    def get_queryset(self):
        # Validate the type parameter
        product_type = self.request.query_params.get('type')
        if product_type not in ['exchange', 'donation']:
             return Response(
                {'error': 'Invalid or missing type parameter. Must be "exchange" or "donation".'},
                status=status.HTTP_400_BAD_REQUEST
            )
        return super().get_queryset().filter(type=product_type)

    def post(self, request):
        # Validate and save the product
        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            product_type = serializer.validated_data.get('type')
            serializer.save()
            
            platform_message = (
                "Product posted to the Exchange platform."
                if product_type == 'exchange'
                else "Product posted to the Donation platform."
            )
            return Response(
                {'msg': 'Product posted successfully', 'platform': platform_message},
                status=status.HTTP_201_CREATED
            )
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    
class Product_DetailsView(APIView):
    def get(self,request,pk):
        try:
            product = Product.objects.get(pk=pk)
            serializers = ProductSerializer(product)
            
            return Response(serializers.data)
            
        except Product.DoesNotExist:    
            return Response({'error' : 'Product not found'}, status=status.HTTP_404_NOT_FOUND)
    
    def put(self, request,pk):
        product = Product.objects.get(pk=pk)
        serializers= ProductSerializer(product, data= request.data)
        
        if serializers.is_valid():
            serializers.save()
            return Response(serializers.data)
        else:
            return Response(serializers.errors,status=status.HTTP_400_BAD_REQUEST)
    def delete(self,request,pk):
        product = Product.objects.get(pk=pk)
        product.delete()
        return Response({'msg' : 'Deleted product'}, status= status.HTTP_204_NO_CONTENT)
    
class CommentListView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)  # Associate the comment with the logged-in user
            return Response({'msg': 'Comment Posted Successfully'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    def get(self, request):
        product_id = request.query_params.get('product')  # Get 'product' query param
        if product_id:
            comments = Comment.objects.filter(product_id=product_id)  # Filter by product
        else:
            comments = Comment.objects.all()
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data)
    
    
class CommentUpdateView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request,pk):
        comment = Comment.objects.get(pk=pk)
        serializers= CommentSerializer(comment, data= request.data)
        
        if serializers.is_valid():
            serializers.save()
            return Response(serializers.data)
        else:
            return Response(serializers.errors,status=status.HTTP_400_BAD_REQUEST)
    def delete(self,request,pk):
        comment = Comment.objects.get(pk=pk)
        comment.delete()
        return Response({'msg' : 'Deleted product'}, status= status.HTTP_204_NO_CONTENT)
    
        
class LikeToggleView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self,request,pk):
        product = get_object_or_404(Product, pk=pk)
        like, created = Like.objects.get_or_create(user=request.user, product=product)
       
        if created:
            serializer = LikeSerializer(like)
            return Response({'status': 'liked','like': serializer.data}, status=status.HTTP_201_CREATED)
        else:
            like.delete()
            return Response({'status': 'unliked'}, status=status.HTTP_200_OK)

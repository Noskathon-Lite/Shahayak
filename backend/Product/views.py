from django.shortcuts import render
from .serializers import *
from rest_framework import generics
from rest_framework.views import APIView
from .models import Product
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated


# Create your views here.


class ProductListView(APIView):
    
    def get(self, request):

        product_type = request.query_params.get('type')
        
        if product_type not in ['exchange', 'donation']:
            return Response(
                {'error': 'Invalid or missing type parameter. Must be "exchange" or "donation".'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        product = Product.objects.filter(type=product_type) #filters the product on the basis of their type
        serializers = ProductSerializer(product, many = True)
        return Response(serializers.data)
     
    def post(self, request):
        serializers=ProductSerializer(data = request.data)
        if serializers.is_valid():
            product_type = serializers.validated_data.get('type')
            serializers.save()
            
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
             return Response(serializers.errors, status=status.HTTP_400_BAD_REQUEST)

    
    
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
    
        
        


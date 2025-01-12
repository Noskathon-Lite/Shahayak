from django.shortcuts import render
from .serializers import *
from rest_framework import generics
from rest_framework.views import APIView
from .models import Product
from rest_framework.response import Response
from rest_framework import status

# Create your views here.


class ProductListView(APIView):
    def get(self, request):
        product = Product.objects.all()
        serializers = ProductSerializer(product, many = True)
        return Response(serializers.data)
     
    def post(self, request):
        serializers=ProductSerializer(data = request.data)
        if serializers.is_valid():
            serializers.save()
            return Response({'msg': 'Product post successfully'}, status = status.HTTP_201_CREATED)
        else:
            return Response(serializers.errors)

            
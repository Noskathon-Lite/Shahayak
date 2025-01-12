from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import *
from rest_framework import status
from django.contrib.auth import authenticate
from .renderers import UserRenderer 
from rest_framework_simplejwt.tokens import RefreshToken

# Create your views here.

def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)

    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }
    

class UserLoginView(APIView):
    renderer_classes = [UserRenderer]
    def post(self, request):
        serializer = UserLoginSerializer(data = request.data)
        
        if serializer.is_valid(raise_exception=True):
            email = serializer.data.get('email')
            password = serializer.data.get('password')
            user = authenticate(email = email, password = password)
            if user is not None:
                token = get_tokens_for_user(user)
                return Response({'token':token,'msg': 'Logged in successfully'}, status=status.HTTP_200_OK)
            else:
                return Response({'error' : {'non_field_error': ['Email or Password is invalid']}}, status = status.HTTP_404_NOT_FOUND)
        
        
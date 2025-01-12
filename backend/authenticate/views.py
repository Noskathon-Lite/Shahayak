from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import *
from rest_framework import status
from django.contrib.auth import authenticate
from .renderers import UserRenderer 
from rest_framework_simplejwt.tokens import RefreshToken
from .models import Profile
from rest_framework.permissions import IsAuthenticated
from .emails import *

# Create your views here.

def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)

    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }
 
 
class UserRegistrationView(APIView):
    renderer_classes = [UserRenderer]
    def post(self, request):
        serializer = UserRegisterSerializer(data = request.data)
        
        if serializer.is_valid(raise_exception=True):
            user = serializer.save()
            send_otp_via_email(serializer.data['email'])
            token = get_tokens_for_user(user)
            Profile.objects.get_or_create(user=user)
            return Response({'token': token,'msg' : 'Registration succesful','data': serializer.data}, status = status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
    
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
        
class SendEmail(APIView):
    pass       

class ProfileDetailView(APIView):
    permission_classes = [IsAuthenticated]
    renderer_classes = [UserRenderer]

    def get(self, request):
        try:
            # Retrieve the profile of the currently authenticated user
            profile = Profile.objects.get(user=request.user)
            serializer = ProfileSerializer(profile)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Profile.DoesNotExist:
            return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)

    def put(self, request):
        try:
            # Retrieve the profile of the currently authenticated user
            profile = Profile.objects.get(user=request.user)
            # Update the profile using the serializer
            serializer = ProfileSerializer(profile, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Profile.DoesNotExist:
            return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)

    def delete(self, request):
        try:
            # Retrieve and delete the profile of the currently authenticated user
            profile = Profile.objects.get(user=request.user)
            profile.delete()
            return Response({'msg': 'Profile deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
        except Profile.DoesNotExist:
            return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)

class VerifyOTP(APIView):
    def post(self, request):
        try:
            data = request.data
            serializer = VerifyAccountSerializer(data=data)
            
        
            if serializer.is_valid(raise_exception=True):
                email = serializer.validated_data['email']
                otp = serializer.validated_data['otp']
                
                
                user = User.objects.filter(email=email)
                if not user.exists():
                    return Response({'msg': 'User does not exist'}, status=status.HTTP_400_BAD_REQUEST)
                
                user = user.first()
                
            
                if user.otp != otp:
                    return Response({'msg': 'Wrong OTP'}, status=status.HTTP_400_BAD_REQUEST)
                
            
                user.is_verified = True
                user.save()
                
                return Response({'msg': 'Account verified', 'data': serializer.data}, status=status.HTTP_201_CREATED)

        except Exception as e:
            # Log the exception
            print(f"Error: {str(e)}")
            # Return a generic error message
            return Response({'msg': 'An error occurred, please try again later.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
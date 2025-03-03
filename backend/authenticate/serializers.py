from rest_framework import serializers
from .models import User,Profile

class UserRegisterSerializer(serializers.ModelSerializer):
    password2= serializers.CharField(style = {'input_type': 'password' }, write_only= True)
    class Meta:
        model = User
        fields = ('email', 'username', 'password', 'password2')
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def validate(self,attrs):
        password = attrs.get('password')
        password2 = attrs.get('password2')
        
        if password != password2:
            raise serializers.ValidationError("Password and Confirm password do not match")
        return attrs 
    
    def create(self, validate_data):
        return User.objects.create_user(**validate_data)

class UserLoginSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(max_length=255)
    class Meta:
        model = User
        fields = [
            'email', 
            'password',
        ]
        
class UserRegisterSerializer(serializers.ModelSerializer):
    password2= serializers.CharField(style = {'input_type': 'password' }, write_only= True)
    class Meta:
        model = User
        fields = ('email', 'username', 'password', 'password2', 'is_verified')
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def validate(self,attrs):
        password = attrs.get('password')
        password2 = attrs.get('password2')
        
        if password != password2:
            raise serializers.ValidationError("Password and Confirm password do not match")
        return attrs 
    
    def create(self, validate_data):
        return User.objects.create_user(**validate_data)

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['profile_picture','phone_number','about']

class VerifyAccountSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=4)
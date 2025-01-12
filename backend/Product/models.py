from django.db import models
from authenticate.models import User
from django.conf import settings

# Create your models here.
class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name

def get_category_choices():
    return [(category.name.lower(), category.name) for category in Category.objects.all()]

class Product(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    product_name = models.CharField(max_length=255)
    category = models.CharField(
        max_length=50,
        choices=get_category_choices,  # Fetch choices dynamically
        default='clothes'
    )
    image = models.ImageField(default='images/', upload_to='images/product/')
    price = models.FloatField()
    purchase_date = models.CharField(max_length=255)
    product_condition = models.CharField(max_length=255)
    caption = models.CharField(max_length=255)
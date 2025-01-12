from django.db import models
from django.conf import settings

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Product(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    product_name = models.CharField(max_length=255)
    category = models.CharField(
        max_length=50,
        choices=[]  
    )
    image = models.ImageField(default='images/', upload_to='images/product/')
    price = models.FloatField()
    purchase_date = models.CharField(max_length=255)
    product_condition = models.CharField(max_length=255)
    caption = models.CharField(max_length=255)

    @staticmethod
    def get_category_choices():
        """Fetch all categories from the Category model."""
        categories = Category.objects.all()
        return [(category.name.lower(), category.name) for category in categories]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Dynamically set choices for the category field
        self._meta.get_field('category').choices = self.get_category_choices()

    def __str__(self):
        return self.product_name

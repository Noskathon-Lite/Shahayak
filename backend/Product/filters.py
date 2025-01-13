import django_filters
from .models import Product

class ProductFilter(django_filters.FilterSet):
    class Meta:
        model = Product
        fields = {
            'price': ['exact', 'lte', 'gte'],       # Exact, less than or equal, greater than or equal
            'category' : ['exact', 'icontains'],    # Exact match and case-insensitive contains      
        }

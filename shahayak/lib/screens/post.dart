class Post {
  int id;
  String productName;
  String category;
  String type;
  String imageUrl;
  double price;
  DateTime purchaseDate;
  String productCondition;
  String caption;

  Post({
    required this.id,
    required this.productName,
    required this.category,
    required this.type,
    required this.imageUrl,
    required this.price,
    required this.purchaseDate,
    required this.productCondition,
    required this.caption,
  });

  // Static method to provide mock posts
  static List<Post> getPosts() {
    return [
      Post(
        id: 1,
        productName: 'Smartphone',
        category: 'Electronics',
        type: 'Exchange',
        imageUrl: 'assets/smartphone.jpg',
        price: 300,
        purchaseDate: DateTime(2023, 1, 10),
        productCondition: 'Used',
        caption: 'A barely used smartphone in excellent condition.',
      ),
      Post(
        id: 2,
        productName: 'Laptop',
        category: 'Electronics',
        type: 'Donation',
        imageUrl: 'assets/laptop.jpg',
        price: 0,
        purchaseDate: DateTime(2022, 5, 15),
        productCondition: 'Like New',
        caption: 'A laptop I don\'t use anymore.Free to anyone who needs it.',
      ),
    ];
  }

  // Factory constructor to create a Post object from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      productName: json['productName'] ?? 'Unknown',
      category: json['category'] ?? 'General',
      type: json['type'] ?? 'Unknown',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      productCondition: json['productCondition'] ?? 'Unknown',
      caption: json['caption'] ?? '',
    );
  }

  // Method to convert a Post object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'category': category,
      'type': type,
      'imageUrl': imageUrl,
      'price': price,
      'purchaseDate': purchaseDate.toIso8601String(),
      'productCondition': productCondition,
      'caption': caption,
    };
  }
}

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
    ];
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      productName: json['productName'],
      category: json['category'],
      type: json['type'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      productCondition: json['productCondition'],
      caption: json['caption'],
    );
  }
}

class Post {
  String productName;
  String category;
  String type;
  String imageUrl; // URL of the image or asset path
  double price;
  DateTime purchaseDate;
  String productCondition;
  String caption;

  Post({
    required this.productName,
    required this.category,
    required this.type,
    required this.imageUrl,
    required this.price,
    required this.purchaseDate,
    required this.productCondition,
    required this.caption,
  });

  // Example function to generate posts, you can modify it based on your needs.
  static List<Post> getPosts() {
    return [
      Post(
        productName: 'Smartphone',
        category: 'Electronics',
        type: 'Exchange',
        imageUrl: 'assets/images/smartphone.png',
        price: 300,
        purchaseDate: DateTime(2023, 1, 10),
        productCondition: 'Used',
        caption: 'A barely used smartphone in excellent condition.',
      ),
      // Add more sample posts here
    ];
  }
}

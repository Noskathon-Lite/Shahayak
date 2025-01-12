class Post {
  final String title;
  final String category;
  final double price;
  final String type;
  Post(
      {required this.title,
      required this.category,
      required this.price,
      required this.type});
  static List<Post> getPosts() {
    return [
      Post(title: 'Item 1 ', category: 'books', price: 500, type: 'Donation'),
      Post(
          title: 'Item 2',
          category: 'electronics',
          price: 3000,
          type: 'Exchange'),
      Post(
          title: 'Item 3', category: 'clothing', price: 1000, type: 'Donation'),
    ];
  }
}

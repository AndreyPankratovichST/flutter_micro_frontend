class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.thumbnail,
  });
}

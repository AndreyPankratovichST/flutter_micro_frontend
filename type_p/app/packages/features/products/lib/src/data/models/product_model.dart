class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? thumbnail;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
    };
  }
}

class Product {
  final String id;
  final String sellerId;
  final String title;
  final String category;
  final String condition;
  final double price;
  final String? description;
  final int stock;
  final List<String> imageUrls;

  Product({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.category,
    required this.condition,
    required this.price,
    this.description,
    this.stock = 1,
    this.imageUrls = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      sellerId: json['seller_id'].toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      condition: json['condition'] ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      stock: json['stock'] ?? 1,
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'])
          : [],
    );
  }
}

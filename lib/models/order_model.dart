import 'product_model.dart';

class Order {
  final String id;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final Product? featuredProduct;

  Order({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.featuredProduct,
  });
}

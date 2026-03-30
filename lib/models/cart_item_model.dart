import 'product_model.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  bool isSelected;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });
}

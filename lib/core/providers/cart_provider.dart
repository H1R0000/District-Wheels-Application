import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/cart_item_model.dart';
import '../../models/product_model.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  final _supabase = Supabase.instance.client;

  @override
  List<CartItem> build() {
    _loadCart();
    return [];
  }

  Future<void> _loadCart() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await _supabase
          .from('cart')
          .select('id, quantity, products(*)')
          .eq('user_id', userId);

      final List<CartItem> loadedItems = (response as List).map((item) {
        return CartItem(
          id: item['id'].toString(),
          product: Product.fromJson(item['products']),
          quantity: item['quantity'],
          isSelected: true,
        );
      }).toList();

      state = loadedItems;
    } catch (e) {
      print("Error loading cart: $e");
    }
  }

  void toggleSelection(String cartItemId) {
    state = state.map((item) {
      if (item.id == cartItemId) {
        return CartItem(
          id: item.id,
          product: item.product,
          quantity: item.quantity,
          isSelected: !item.isSelected,
        );
      }
      return item;
    }).toList();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    state = state.map((item) {
      if (item.id == cartItemId) {
        int safeQuantity = newQuantity.clamp(1, item.product.stock);

        return CartItem(
          id: item.id,
          product: item.product,
          quantity: safeQuantity,
          isSelected: item.isSelected,
        );
      }
      return item;
    }).toList();

    final updatedItem = state.firstWhere((item) => item.id == cartItemId);
    _supabase
        .from('cart')
        .update({'quantity': updatedItem.quantity})
        .eq('id', cartItemId)
        .catchError((error) => print("Error updating quantity in DB: $error"));
  }

  void toggleShopSelection(String sellerId, bool isSelected) {
    state = state.map((item) {
      if (item.product.sellerId == sellerId) {
        return CartItem(
          id: item.id,
          product: item.product,
          quantity: item.quantity,
          isSelected: isSelected,
        );
      }
      return item;
    }).toList();
  }

  double get totalPrice {
    return state
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});

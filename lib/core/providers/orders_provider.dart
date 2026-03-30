import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';

final ordersProvider = FutureProvider<List<Order>>((ref) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return [];

  try {
    final response = await supabase
        .from('orders')
        .select('*, order_items(*, products(*))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((orderData) {
      final items = (orderData['order_items'] as List?) ?? [];
      Product? displayProduct;

      if (items.isNotEmpty && items[0]['products'] != null) {
        displayProduct = Product.fromJson(items[0]['products']);
      }

      return Order(
        id: orderData['id'].toString(),
        totalPrice: (orderData['total_price'] as num).toDouble(),
        status: orderData['order_status'] ?? 'Pending',
        createdAt: DateTime.parse(orderData['created_at']),
        featuredProduct: displayProduct,
      );
    }).toList();
  } catch (e) {
    print('Error fetching orders: $e');
    return [];
  }
});

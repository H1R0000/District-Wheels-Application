import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/database_service.dart';
import '../../models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getFeaturedProducts();
});
final sellerProductsProvider = FutureProvider<List<Product>>((ref) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return [];

  final response = await supabase
      .from('products')
      .select()
      .eq('seller_id', userId)
      .order('created_at', ascending: false);

  return (response as List).map((item) => Product.fromJson(item)).toList();
});

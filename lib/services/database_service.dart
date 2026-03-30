import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/notification_model.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> toggleFavorite(
    String productId,
    bool isCurrentlyFavorited,
  ) async {
    final userId = _supabase.auth.currentUser!.id;

    if (isCurrentlyFavorited) {
      await _supabase.from('favorites').delete().match({
        'user_id': userId,
        'product_id': productId,
      });
    } else {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'product_id': productId,
      });
    }
  }

  Future<List<AppNotification>> getNotifications() async {
    final userId = _supabase.auth.currentUser!.id;

    final response = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => AppNotification.fromJson(item))
        .toList();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> updateListing({
    required String productId,
    required String title,
    required String category,
    required String condition,
    required double price,
    String? description,
  }) async {
    await _supabase
        .from('products')
        .update({
          'title': title,
          'category': category,
          'condition': condition,
          'price': price,
          'description': description,
        })
        .eq('id', productId);
  }

  Future<void> deleteListing(String productId) async {
    await _supabase.from('products').delete().eq('id', productId);
  }

  Future<List<Product>> getFavoriteProducts() async {
    final userId = _supabase.auth.currentUser!.id;

    final response = await _supabase
        .from('favorites')
        .select('product_id, products(*)')
        .eq('user_id', userId);

    return (response as List)
        .map((item) => Product.fromJson(item['products']))
        .toList();
  }

  Future<void> createListing({
    required String title,
    required String category,
    required String condition,
    required double price,
    required int stock,
    String? description,
    List<XFile>? imageFiles,
  }) async {
    final userId = _supabase.auth.currentUser!.id;
    List<String> uploadedUrls = [];

    if (imageFiles != null && imageFiles.isNotEmpty) {
      for (var imageFile in imageFiles) {
        final fileExt = imageFile.name.split('.').last;
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
        final imageBytes = await imageFile.readAsBytes();

        await _supabase.storage
            .from('product-images')
            .uploadBinary(
              fileName,
              imageBytes,
              fileOptions: FileOptions(contentType: 'image/$fileExt'),
            );

        final publicUrl = _supabase.storage
            .from('product-images')
            .getPublicUrl(fileName);

        uploadedUrls.add(publicUrl);
      }
    }

    await _supabase.from('products').insert({
      'seller_id': userId,
      'title': title,
      'category': category,
      'condition': condition,
      'price': price,
      'stock': stock,
      'description': description,
      'image_urls': uploadedUrls,
    });
  }

  Future<void> placeOrder({
    required double totalPrice,
    required String paymentMethod,
    required String shippingAddress,
    required String phoneNumber,
    required List<CartItem> cartItems,
  }) async {
    final userId = _supabase.auth.currentUser!.id;

    final orderResponse = await _supabase
        .from('orders')
        .insert({
          'user_id': userId,
          'total_price': totalPrice,
          'payment_method': paymentMethod,
          'shipping_address': shippingAddress,
          'phone_number': phoneNumber,
          'order_status': 'To Ship',
        })
        .select()
        .single();

    final orderId = orderResponse['id'];

    final orderItemsData = cartItems
        .map(
          (item) => {
            'order_id': orderId,
            'product_id': item.product.id,
            'quantity': item.quantity,
            'price': item.product.price,
          },
        )
        .toList();

    await _supabase.from('order_items').insert(orderItemsData);

    final cartItemIds = cartItems.map((item) => item.id).toList();
    if (cartItemIds.isNotEmpty) {
      await _supabase.from('cart').delete().inFilter('id', cartItemIds);
    }

    for (var item in cartItems) {
      try {
        await _supabase.rpc(
          'decrement_stock',
          params: {'p_id': item.product.id, 'qty': item.quantity},
        );
      } catch (e) {
        print("Stock decrement failed: $e");
      }

      if (item.product.sellerId != userId) {
        await _supabase.from('notifications').insert({
          'user_id': item.product.sellerId,
          'title': 'New Order Received! 📦',
          'message':
              'Awesome! Someone just bought ${item.quantity}x of your "${item.product.title}". Please prepare it for shipping.',
          'is_read': false,
        });
      }
    }
  }

  Future<void> addToCart(Product product) async {
    final userId = _supabase.auth.currentUser!.id;

    final existingCartItem = await _supabase.from('cart').select().match({
      'user_id': userId,
      'product_id': product.id,
    }).maybeSingle();

    if (existingCartItem != null) {
      int currentQty = existingCartItem['quantity'];
      if (currentQty < product.stock) {
        await _supabase
            .from('cart')
            .update({'quantity': currentQty + 1})
            .eq('id', existingCartItem['id']);
      } else {
        throw Exception(
          'You already have the maximum available stock (${product.stock}) in your cart!',
        );
      }
    } else {
      if (product.stock > 0) {
        await _supabase.from('cart').insert({
          'user_id': userId,
          'product_id': product.id,
          'quantity': 1,
        });
      } else {
        throw Exception('This item is currently out of stock.');
      }
    }
  }

  Future<List<Product>> getFeaturedProducts() async {
    final response = await _supabase
        .from('products')
        .select()
        .gt('stock', 0)
        .order('created_at', ascending: false);

    return (response as List).map((item) => Product.fromJson(item)).toList();
  }
}

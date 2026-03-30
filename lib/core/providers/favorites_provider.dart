import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product_model.dart';
import 'products_provider.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Product>>((ref) {
      return FavoritesNotifier(ref);
    });

class FavoritesNotifier extends StateNotifier<List<Product>> {
  final Ref ref;

  FavoritesNotifier(this.ref) : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final dbService = ref.read(databaseServiceProvider);
    final favs = await dbService.getFavoriteProducts();
    state = favs;
  }

  bool isFavorite(String productId) {
    return state.any((product) => product.id == productId);
  }

  Future<void> toggleFavorite(Product product) async {
    final isFav = isFavorite(product.id);
    final dbService = ref.read(databaseServiceProvider);

    if (isFav) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }

    try {
      await dbService.toggleFavorite(product.id, isFav);
    } catch (e) {
      _loadFavorites();
    }
  }
}

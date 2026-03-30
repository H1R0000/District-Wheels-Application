import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../core/providers/favorites_provider.dart';
import 'product_details_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  final VoidCallback? onBack;

  const FavoritesScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteProducts = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppTheme.brandYellow,
              image: DecorationImage(
                image: AssetImage('images/ybg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (onBack != null) {
                          onBack!();
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.brandBlack,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'FAVORITES',
                          style: AppTheme.mainHeader.copyWith(fontSize: 44),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Messaging coming soon!'),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.chat_bubble,
                            color: AppTheme.brandBlack,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: favoriteProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: AppTheme.brandGrey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: AppTheme.bodyText.copyWith(
                            color: AppTheme.brandGrey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.80,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(product: product),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: AppTheme.brandWhite,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: product.imageUrls.isNotEmpty
                                          ? Image.network(
                                              product.imageUrls.first,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons.directions_car,
                                              size: 50,
                                              color: AppTheme.brandGrey,
                                            ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => ref
                                            .read(favoritesProvider.notifier)
                                            .toggleFavorite(product),
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: AppTheme.brandBlack
                                                .withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.favorite,
                                            size: 20,
                                            color: AppTheme.brandYellow,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.title,
                              style: AppTheme.subHeader.copyWith(
                                color: AppTheme.brandWhite,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'P${product.price.toStringAsFixed(2)}',
                              style: AppTheme.mainHeader.copyWith(
                                color: AppTheme.brandYellow,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

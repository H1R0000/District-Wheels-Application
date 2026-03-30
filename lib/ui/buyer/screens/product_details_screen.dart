import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../models/product_model.dart';
import '../../../core/providers/products_provider.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/providers/favorites_provider.dart';
import 'checkout_screen.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref
        .watch(favoritesProvider.notifier)
        .isFavorite(widget.product.id);

    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Stack(
              children: [
                widget.product.imageUrls.isNotEmpty
                    ? PageView.builder(
                        controller: _pageController,
                        itemCount: widget.product.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: AppTheme.brandWhite,
                            child: Image.network(
                              widget.product.imageUrls[index],
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppTheme.brandWhite,
                        child: const Center(
                          child: Icon(
                            Icons.directions_car,
                            size: 100,
                            color: AppTheme.brandGrey,
                          ),
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.brandBlack.withOpacity(0.0),
                          AppTheme.brandBlack,
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.product.imageUrls.length > 1) ...[
                  Positioned(
                    left: 10,
                    top: 150,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.brandBlack,
                        size: 30,
                      ),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 150,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.brandBlack,
                        size: 30,
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ],
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: AppTheme.brandBlack,
                          size: 28,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(favoritesProvider.notifier)
                              .toggleFavorite(widget.product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Removed from favorites'
                                    : 'Added to favorites!',
                                style: AppTheme.subHeader.copyWith(
                                  color: AppTheme.brandBlack,
                                ),
                              ),
                              backgroundColor: AppTheme.brandYellow,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: AppTheme.brandBlack,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.storefront,
                          color: AppTheme.brandWhite,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SHOP NAME',
                          style: AppTheme.mainHeader.copyWith(
                            color: AppTheme.brandWhite,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.chat_bubble,
                      color: AppTheme.brandWhite,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.product.title.toUpperCase(),
                  style: AppTheme.mainHeader.copyWith(
                    color: AppTheme.brandWhite,
                    fontSize: 28,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'P${widget.product.price.toStringAsFixed(2)}',
                    style: AppTheme.mainHeader.copyWith(
                      color: AppTheme.brandYellow,
                      fontSize: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CATEGORY',
                            style: AppTheme.subHeader.copyWith(
                              color: AppTheme.brandWhite,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: AppTheme.brandWhite,
                            ),
                            child: Text(
                              widget.product.category,
                              style: AppTheme.subHeader.copyWith(
                                color: AppTheme.brandBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONDITION',
                            style: AppTheme.subHeader.copyWith(
                              color: AppTheme.brandWhite,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: AppTheme.brandWhite,
                            ),
                            child: Text(
                              widget.product.condition,
                              style: AppTheme.subHeader.copyWith(
                                color: AppTheme.brandBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'DESCRIPTION',
                  style: AppTheme.mainHeader.copyWith(
                    color: AppTheme.brandYellow,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 80,
                    ),
                    decoration: const BoxDecoration(color: AppTheme.brandWhite),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.product.description ??
                            'No description provided.',
                        style: AppTheme.bodyText.copyWith(
                          color: AppTheme.brandBlack,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandYellow,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              try {
                                final dbService = ref.read(
                                  databaseServiceProvider,
                                );
                                await dbService.addToCart(widget.product);
                                ref.invalidate(cartProvider);

                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CheckoutScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'BUY NOW',
                              style: AppTheme.subHeader.copyWith(
                                color: AppTheme.brandBlack,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandYellow,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              try {
                                final dbService = ref.read(
                                  databaseServiceProvider,
                                );
                                await dbService.addToCart(widget.product);
                                ref.invalidate(cartProvider);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added to Cart!',
                                        style: AppTheme.subHeader.copyWith(
                                          color: AppTheme.brandBlack,
                                        ),
                                      ),
                                      backgroundColor: AppTheme.brandYellow,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'ADD TO CART',
                              style: AppTheme.subHeader.copyWith(
                                color: AppTheme.brandBlack,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

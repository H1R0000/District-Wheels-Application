import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../theme/app_theme.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../models/cart_item_model.dart';
import 'checkout_screen.dart';
import 'favorites_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;

  const CartScreen({super.key, this.onBack});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isEditing = false;
  bool _isLoading = false;

  Future<void> _deleteSelectedItems(List<String> selectedIds) async {
    if (selectedIds.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client
          .from('cart')
          .delete()
          .inFilter('id', selectedIds);

      ref.invalidate(cartProvider);

      setState(() => _isEditing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Items removed from cart.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error removing items: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).totalPrice;

    final selectedIds = cartItems
        .where((i) => i.isSelected)
        .map((i) => i.id)
        .toList();

    final Map<String, List<CartItem>> groupedCart = {};
    for (var item in cartItems) {
      final sellerId = item.product.sellerId;
      if (!groupedCart.containsKey(sellerId)) {
        groupedCart[sellerId] = [];
      }
      groupedCart[sellerId]!.add(item);
    }

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
                  bottom: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (widget.onBack != null) {
                                  widget.onBack!();
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
                            const SizedBox(width: 8),
                            Text(
                              'CART (${cartItems.length})',
                              style: AppTheme.mainHeader.copyWith(fontSize: 36),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FavoritesScreen(),
                                ),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: AppTheme.brandBlack,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.chat_bubble,
                                color: AppTheme.brandBlack,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => setState(() => _isEditing = !_isEditing),
                      child: Text(
                        _isEditing ? 'DONE' : 'EDIT',
                        style: AppTheme.subHeader.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: AppTheme.brandGrey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: AppTheme.bodyText.copyWith(
                            color: AppTheme.brandGrey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: groupedCart.keys.length,
                    itemBuilder: (context, index) {
                      final sellerId = groupedCart.keys.elementAt(index);
                      final shopItems = groupedCart[sellerId]!;
                      final isShopFullySelected = shopItems.every(
                        (item) => item.isSelected,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    value: isShopFullySelected,
                                    activeColor: AppTheme.brandYellow,
                                    checkColor: AppTheme.brandBlack,
                                    side: const BorderSide(
                                      color: AppTheme.brandYellow,
                                      width: 2,
                                    ),
                                    onChanged: (bool? newValue) {
                                      ref
                                          .read(cartProvider.notifier)
                                          .toggleShopSelection(
                                            sellerId,
                                            newValue ?? false,
                                          );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.storefront,
                                  color: AppTheme.brandWhite,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'SELLER SHOP',
                                    style: AppTheme.mainHeader.copyWith(
                                      color: AppTheme.brandWhite,
                                      fontSize: 24,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...shopItems.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: item.isSelected,
                                        activeColor: AppTheme.brandYellow,
                                        checkColor: AppTheme.brandBlack,
                                        side: const BorderSide(
                                          color: AppTheme.brandYellow,
                                          width: 2,
                                        ),
                                        onChanged: (_) => ref
                                            .read(cartProvider.notifier)
                                            .toggleSelection(item.id),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: AppTheme.brandWhite,
                                        image: item.product.imageUrls.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  item.product.imageUrls.first,
                                                ),
                                                fit: BoxFit.contain,
                                              )
                                            : null,
                                      ),
                                      child: item.product.imageUrls.isEmpty
                                          ? const Icon(
                                              Icons.directions_car,
                                              color: AppTheme.brandGrey,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product.title,
                                            style: AppTheme.subHeader.copyWith(
                                              color: AppTheme.brandWhite,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'P${item.product.price.toStringAsFixed(2)}',
                                            style: AppTheme.mainHeader.copyWith(
                                              color: AppTheme.brandYellow,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (item.quantity > 1) {
                                                    ref
                                                        .read(
                                                          cartProvider.notifier,
                                                        )
                                                        .updateQuantity(
                                                          item.id,
                                                          item.quantity - 1,
                                                        );
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: AppTheme.brandWhite,
                                                  size: 28,
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4,
                                                    ),
                                                color: AppTheme.brandWhite,
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: AppTheme.subHeader
                                                      .copyWith(fontSize: 18),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (item.quantity <
                                                      item.product.stock) {
                                                    ref
                                                        .read(
                                                          cartProvider.notifier,
                                                        )
                                                        .updateQuantity(
                                                          item.id,
                                                          item.quantity + 1,
                                                        );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'There is no more extra stock for this item!',
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                        duration: Duration(
                                                          seconds: 2,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      item.quantity >=
                                                          item.product.stock
                                                      ? AppTheme.brandGrey
                                                      : AppTheme.brandWhite,
                                                  size: 28,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          color: AppTheme.brandYellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TOTAL',
                    style: AppTheme.mainHeader.copyWith(fontSize: 12),
                  ),
                  Text(
                    'P${total.toStringAsFixed(2)}',
                    style: AppTheme.mainHeader.copyWith(fontSize: 24),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing
                      ? Colors.red
                      : AppTheme.brandWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: _isLoading || selectedIds.isEmpty
                    ? null
                    : () {
                        if (_isEditing) {
                          _deleteSelectedItems(selectedIds);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          );
                        }
                      },
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppTheme.brandWhite,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _isEditing
                            ? 'DELETE (${selectedIds.length})'
                            : 'CHECK OUT',
                        style: AppTheme.subHeader.copyWith(
                          color: _isEditing
                              ? AppTheme.brandWhite
                              : AppTheme.brandBlack,
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/providers/products_provider.dart';
import '../../../core/providers/profile_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'Cash on Delivery';
  final double _shippingFee = 10.00;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref
        .watch(cartProvider)
        .where((item) => item.isSelected)
        .toList();
    final merchandiseSubtotal = ref.read(cartProvider.notifier).totalPrice;
    final totalPayment = merchandiseSubtotal + _shippingFee;

    final userProfile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppTheme.brandWhite,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/carbg.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.brandBlack.withOpacity(0.6),
                          ),
                          child: SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: AppTheme.brandWhite,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'CHECKOUT',
                                    style: AppTheme.mainHeader.copyWith(
                                      color: AppTheme.brandWhite,
                                      fontSize: 48,
                                      letterSpacing: -2.0,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 170,
                          left: 16,
                          right: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.brandWhite,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.brandBlack.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppTheme.brandBlack,
                              size: 36,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${userProfile.name.toUpperCase()}  ',
                                        style: AppTheme.mainHeader.copyWith(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        userProfile.phone,
                                        style: AppTheme.bodyText.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userProfile.address,
                                    style: AppTheme.bodyText.copyWith(
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.storefront,
                              color: AppTheme.brandBlack,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'SHOP NAME',
                              style: AppTheme.mainHeader.copyWith(fontSize: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ...cartItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  color: AppTheme.brandWhite,
                                  child: item.product.imageUrls.isNotEmpty
                                      ? Image.network(
                                          item.product.imageUrls.first,
                                          fit: BoxFit.contain,
                                        )
                                      : const Icon(
                                          Icons.directions_car,
                                          color: AppTheme.brandGrey,
                                        ),
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
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'P${item.product.price.toStringAsFixed(2)}',
                                        style: AppTheme.mainHeader.copyWith(
                                          fontSize: 16,
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
                                                    .read(cartProvider.notifier)
                                                    .updateQuantity(
                                                      item.id,
                                                      item.quantity - 1,
                                                    );
                                              }
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              size: 24,
                                              color: AppTheme.brandBlack,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            color: AppTheme.brandBlack,
                                            child: Text(
                                              '${item.quantity}',
                                              style: AppTheme.subHeader
                                                  .copyWith(
                                                    color: AppTheme.brandWhite,
                                                    fontSize: 16,
                                                  ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (item.quantity <
                                                  item.product.stock) {
                                                ref
                                                    .read(cartProvider.notifier)
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
                                                    backgroundColor: Colors.red,
                                                    duration: Duration(
                                                      seconds: 2,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              size: 24,
                                              color: AppTheme.brandBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL ITEM',
                              style: AppTheme.mainHeader.copyWith(fontSize: 16),
                            ),
                            Text(
                              'P${merchandiseSubtotal.toStringAsFixed(2)}',
                              style: AppTheme.mainHeader.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: AppTheme.brandBlack,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Methods',
                          style: AppTheme.mainHeader.copyWith(
                            color: AppTheme.brandWhite,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildPaymentOption(
                          title: 'Cash on Delivery',
                          value: 'Cash on Delivery',
                          icon: Icons.money,
                          iconColor: AppTheme.brandYellow,
                        ),
                        const SizedBox(height: 24),
                        _buildPaymentOption(
                          title: 'Gcash',
                          value: 'Gcash',
                          icon: Icons.account_balance_wallet,
                          iconColor: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    color: AppTheme.brandWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Details',
                          style: AppTheme.subHeader.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Merchandise Subtotal',
                              style: AppTheme.bodyText.copyWith(fontSize: 14),
                            ),
                            Text(
                              'P${merchandiseSubtotal.toStringAsFixed(2)}',
                              style: AppTheme.bodyText.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping Subtotal',
                              style: AppTheme.bodyText.copyWith(fontSize: 14),
                            ),
                            Text(
                              'P${_shippingFee.toStringAsFixed(2)}',
                              style: AppTheme.bodyText.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    color: AppTheme.brandPaleYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL PAYMENT',
                          style: AppTheme.mainHeader.copyWith(fontSize: 16),
                        ),
                        Text(
                          'P${totalPayment.toStringAsFixed(2)}',
                          style: AppTheme.mainHeader.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppTheme.brandYellow,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'TOTAL',
                        style: AppTheme.subHeader.copyWith(fontSize: 12),
                      ),
                      Text(
                        'P${totalPayment.toStringAsFixed(2)}',
                        style: AppTheme.mainHeader.copyWith(fontSize: 24),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brandWhite,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            try {
                              setState(() => _isLoading = true);

                              final dbService = ref.read(
                                databaseServiceProvider,
                              );
                              await dbService.placeOrder(
                                totalPrice: totalPayment,
                                paymentMethod: _selectedPaymentMethod,
                                shippingAddress: userProfile.address,
                                phoneNumber: userProfile.phone,
                                cartItems: cartItems,
                              );

                              ref.invalidate(cartProvider);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Order Placed Successfully!',
                                      style: AppTheme.subHeader.copyWith(
                                        color: AppTheme.brandBlack,
                                      ),
                                    ),
                                    backgroundColor: AppTheme.brandYellow,
                                  ),
                                );
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          },
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.brandBlack,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'PLACE ORDER',
                            style: AppTheme.subHeader.copyWith(
                              color: AppTheme.brandBlack,
                              fontSize: 16,
                            ),
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

  Widget _buildPaymentOption({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTheme.subHeader.copyWith(
                color: AppTheme.brandWhite,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.brandWhite : AppTheme.brandBlack,
              border: Border.all(color: AppTheme.brandWhite, width: 3),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: AppTheme.brandBlack, size: 22)
                : null,
          ),
        ],
      ),
    );
  }
}

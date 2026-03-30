import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import 'add_listing_screen.dart';
import '../../shared/profile_screen.dart';
import '../../../core/providers/products_provider.dart';
import '../../../models/product_model.dart';
import 'edit_listing_screen.dart';
import '../../buyer/screens/notifications_screen.dart';

class SellerHomeScreen extends ConsumerStatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  ConsumerState<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends ConsumerState<SellerHomeScreen> {
  int _currentIndex = 0;

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.brandWhite,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'Delete Listing?',
          style: AppTheme.mainHeader.copyWith(fontSize: 20),
        ),
        content: Text(
          'Are you sure you want to delete "${product.title}"? This cannot be undone.',
          style: AppTheme.bodyText.copyWith(color: AppTheme.brandBlack),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: AppTheme.subHeader.copyWith(color: AppTheme.brandBlack),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final dbService = ref.read(databaseServiceProvider);
                await dbService.deleteListing(product.id);

                ref.invalidate(sellerProductsProvider);
                ref.invalidate(featuredProductsProvider);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Listing Deleted',
                        style: AppTheme.subHeader.copyWith(
                          color: AppTheme.brandWhite,
                        ),
                      ),
                      backgroundColor: AppTheme.brandBlack,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text(
              'DELETE',
              style: AppTheme.subHeader.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerListings() {
    final sellerListings = ref.watch(sellerProductsProvider);

    return Column(
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
                top: 24.0,
                bottom: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ACTIVE LISTING',
                    style: AppTheme.mainHeader.copyWith(
                      fontSize: 40,
                      letterSpacing: -2.0,
                      height: 1.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Messaging coming soon!')),
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
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: AppTheme.brandBlack,
            child: sellerListings.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: AppTheme.brandGrey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No active listings yet.',
                          style: AppTheme.bodyText.copyWith(
                            color: AppTheme.brandGrey,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to add one!',
                          style: AppTheme.bodyText.copyWith(
                            color: AppTheme.brandGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.0,
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: AppTheme.brandWhite,
                            ),
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
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'P${product.price.toStringAsFixed(2)}',
                                style: AppTheme.mainHeader.copyWith(
                                  color: AppTheme.brandYellow,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditListingScreen(product: product),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppTheme.brandWhite,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: AppTheme.brandBlack,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _deleteProduct(product),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: AppTheme.brandWhite,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.brandYellow),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: AppTheme.brandWhite),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      appBar: (_currentIndex == 0 || _currentIndex == 2 || _currentIndex == 3)
          ? null
          : AppBar(
              backgroundColor: AppTheme.brandWhite,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppTheme.brandBlack),
              title: Text(
                'SELLER DASHBOARD',
                style: AppTheme.mainHeader.copyWith(fontSize: 16),
              ),
            ),
      body: _currentIndex == 2
          ? NotificationsScreen(onBack: () => setState(() => _currentIndex = 0))
          : _currentIndex == 3
          ? ProfileScreen(onBack: () => setState(() => _currentIndex = 0))
          : _buildSellerListings(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddListingScreen()),
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.brandYellow,
        selectedItemColor: AppTheme.brandBlack,
        unselectedItemColor: AppTheme.brandBlack,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 40, color: AppTheme.brandBlack),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 30),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

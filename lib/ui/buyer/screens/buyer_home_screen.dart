import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../../core/providers/products_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/notifications_provider.dart';
import '../../../models/product_model.dart';
import '../../shared/profile_screen.dart';
import 'product_details_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'cart_screen.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends ConsumerState<BuyerHomeScreen> {
  int _currentIndex = 0;
  int _currentBannerIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  final List<String> _bannerImages = [
    'images/carbg.png',
    'images/slide1.jpg',
    'images/slide2.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentBannerIndex < _bannerImages.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final unreadAlerts = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: _currentIndex == 0
          ? AppTheme.brandBlack
          : AppTheme.brandWhite,
      appBar: null,
      body: _currentIndex == 0
          ? _buildHomeFeed()
          : _currentIndex == 1
          ? FavoritesScreen(onBack: () => setState(() => _currentIndex = 0))
          : _currentIndex == 2
          ? CartScreen(onBack: () => setState(() => _currentIndex = 0))
          : _currentIndex == 3
          ? NotificationsScreen(onBack: () => setState(() => _currentIndex = 0))
          : _currentIndex == 4
          ? ProfileScreen(onBack: () => setState(() => _currentIndex = 0))
          : const Center(child: Text('Coming Soon')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.brandYellow,
        selectedItemColor: AppTheme.brandBlack,
        unselectedItemColor: AppTheme.brandBlack,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 30),
            label: 'Favorites',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 30),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: unreadAlerts > 0,
              backgroundColor: Colors.red,
              label: Text(
                unreadAlerts.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              child: const Icon(Icons.notifications, size: 30),
            ),
            label: 'Alerts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeFeed() {
    final productsAsyncValue = ref.watch(featuredProductsProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final userProfile = ref.watch(profileProvider);

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
                left: 20,
                right: 20,
                top: 16,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 55,
                        color: AppTheme.brandBlack,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          userProfile.name.toUpperCase(),
                          style: AppTheme.mainHeader.copyWith(fontSize: 24),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            ref.read(searchQueryProvider.notifier).state =
                                value;
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppTheme.brandWhite,
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppTheme.brandBlack,
                            ),
                            hintText: 'Search diecast...',
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                color: AppTheme.brandBlack,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                color: AppTheme.brandBlack,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                color: AppTheme.brandBlack,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.chat_bubble,
                        color: AppTheme.brandBlack,
                        size: 36,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: AppTheme.brandBlack,
            child: CustomScrollView(
              slivers: [
                if (searchQuery.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      height: 180,
                      margin: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentBannerIndex = index;
                              });
                            },
                            itemCount: _bannerImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(_bannerImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _bannerImages.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentBannerIndex == index
                                        ? AppTheme.brandYellow
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: AppTheme.brandYellow,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      searchQuery.isEmpty ? 'PRODUCTS' : 'SEARCH RESULTS',
                      style: AppTheme.mainHeader.copyWith(
                        color: AppTheme.brandYellow,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                productsAsyncValue.when(
                  data: (products) {
                    final filteredProducts = products.where((product) {
                      return product.title.toLowerCase().contains(
                            searchQuery,
                          ) ||
                          product.category.toLowerCase().contains(searchQuery);
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'No diecast cars found.',
                              style: TextStyle(color: AppTheme.brandWhite),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.80,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildProductCard(filteredProducts[index]),
                          childCount: filteredProducts.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.brandYellow,
                      ),
                    ),
                  ),
                  error: (err, stack) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(color: AppTheme.brandWhite),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    final favoriteProducts = ref.watch(favoritesProvider);
    final isFavorite = favoriteProducts.any((p) => p.id == product.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: AppTheme.brandWhite),
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
                          color: AppTheme.brandBlack.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
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
            style: AppTheme.subHeader.copyWith(
              color: AppTheme.brandYellow,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../core/providers/user_role_provider.dart';
import '../../core/providers/profile_provider.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  final VoidCallback? onBack;

  const ProfileScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(userRoleProvider);
    final isSeller = currentRole == UserRole.seller;
    final userProfile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      appBar: null,
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble,
                              color: AppTheme.brandBlack,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () async {
                                await AuthService().signOut();
                                if (context.mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.logout,
                                color: AppTheme.brandBlack,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: const BoxDecoration(
                            color: AppTheme.brandBlack,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.brandWhite,
                            size: 70,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSeller
                                    ? "SELLER'S DASHBOARD"
                                    : "BUYERS'S DASHBOARD",
                                style: AppTheme.mainHeader.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                userProfile.name.toUpperCase(),
                                style: AppTheme.mainHeader.copyWith(
                                  fontSize: 28,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                userProfile.bio,
                                style: AppTheme.subHeader.copyWith(
                                  color: AppTheme.brandBlack,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EditProfileScreen(),
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  color: AppTheme.brandWhite,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "EDIT PROFILE",
                                    style: AppTheme.subHeader.copyWith(
                                      color: AppTheme.brandBlack,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
            child: Container(
              color: AppTheme.brandBlack,
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSeller ? "ORDERS" : "PURCHASES",
                    style: AppTheme.mainHeader.copyWith(
                      color: AppTheme.brandYellow,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionIcon(Icons.inventory_2, "TO SHIP"),
                      _buildActionIcon(Icons.local_shipping, "TO RECEIVE"),
                      _buildActionIcon(Icons.stars, "COMPLETED"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppTheme.brandPaleYellow,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SWITCH ACCOUNT",
                    style: AppTheme.mainHeader.copyWith(fontSize: 26),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brandBlack,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(userRoleProvider.notifier)
                          .setRole(isSeller ? UserRole.buyer : UserRole.seller);
                    },
                    child: Text(
                      isSeller ? "BUYER" : "SELLER",
                      style: AppTheme.subHeader.copyWith(
                        color: AppTheme.brandWhite,
                        fontSize: 14,
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

  Widget _buildActionIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Icon(icon, color: AppTheme.brandWhite, size: 60),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTheme.subHeader.copyWith(
              color: AppTheme.brandWhite,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

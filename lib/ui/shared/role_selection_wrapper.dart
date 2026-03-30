import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/user_role_provider.dart';
import '../buyer/screens/buyer_home_screen.dart';
import '../seller/screens/seller_home_screen.dart';

class RoleSelectionWrapper extends ConsumerWidget {
  const RoleSelectionWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(userRoleProvider);
    return currentRole == UserRole.buyer
        ? const BuyerHomeScreen()
        : const SellerHomeScreen();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { buyer, seller }

class UserRoleNotifier extends Notifier<UserRole> {
  @override
  UserRole build() => UserRole.buyer; // Default to buyer
  void setRole(UserRole role) => state = role;
}

final userRoleProvider = NotifierProvider<UserRoleNotifier, UserRole>(
  () => UserRoleNotifier(),
);

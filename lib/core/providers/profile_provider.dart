import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String bio;

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.bio,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['username'] ?? 'Unknown User',
      phone: map['phone_number'] ?? 'No phone number set',
      address: map['address'] ?? 'No address set',
      bio: map['bio'] ?? 'No bio yet.',
    );
  }

  UserProfile copyWith({
    String? name,
    String? phone,
    String? address,
    String? bio,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      bio: bio ?? this.bio,
    );
  }
}

class ProfileNotifier extends Notifier<UserProfile> {
  final _supabase = Supabase.instance.client;

  @override
  UserProfile build() {
    _fetchProfile();
    return UserProfile(
      id: '',
      name: 'Loading...',
      phone: '',
      address: '',
      bio: '',
    );
  }

  Future<void> _fetchProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      state = UserProfile.fromMap(response);
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String bio,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    state = state.copyWith(
      name: name,
      phone: phone,
      address: address,
      bio: bio,
    );

    await _supabase
        .from('users')
        .update({
          'username': name,
          'phone_number': phone,
          'address': address,
          'bio': bio,
        })
        .eq('id', user.id);
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(() {
  return ProfileNotifier();
});

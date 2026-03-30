import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../core/providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final currentProfile = ref.read(profileProvider);

    _nameController = TextEditingController(text: currentProfile.name);
    _phoneController = TextEditingController(text: currentProfile.phone);
    _addressController = TextEditingController(text: currentProfile.address);
    _bioController = TextEditingController(text: currentProfile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    ref
        .read(profileProvider.notifier)
        .updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          bio: _bioController.text.trim(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile Updated!',
          style: AppTheme.subHeader.copyWith(color: AppTheme.brandBlack),
        ),
        backgroundColor: AppTheme.brandYellow,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.brandBlack,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'EDIT PROFILE',
                      style: AppTheme.mainHeader.copyWith(fontSize: 36),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLabel('Full Name'),
                  _buildTextField(_nameController),
                  _buildLabel('Phone Number'),
                  _buildTextField(_phoneController),
                  _buildLabel('Address'),
                  _buildTextField(_addressController, maxLines: 3),
                  _buildLabel('Bio / Subtitle'),
                  _buildTextField(_bioController),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandYellow,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: _saveProfile,
                      child: Text(
                        'SAVE CHANGES',
                        style: AppTheme.subHeader.copyWith(
                          color: AppTheme.brandBlack,
                          fontSize: 18,
                        ),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        text,
        style: AppTheme.subHeader.copyWith(
          color: AppTheme.brandWhite,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTheme.bodyText.copyWith(color: AppTheme.brandBlack),
      decoration: const InputDecoration(
        filled: true,
        fillColor: AppTheme.brandWhite,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}

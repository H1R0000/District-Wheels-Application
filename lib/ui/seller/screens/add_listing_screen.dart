import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../core/providers/products_provider.dart';

class AddListingScreen extends ConsumerStatefulWidget {
  const AddListingScreen({super.key});

  @override
  ConsumerState<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends ConsumerState<AddListingScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _stockController = TextEditingController(text: '1');

  String _category = '1:64';
  String _condition = 'Mint in Box';

  List<XFile> _selectedImages = [];
  bool _isLoading = false;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitListing() async {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please provide at least one image, a title, and a price.',
            style: AppTheme.subHeader.copyWith(color: AppTheme.brandWhite),
          ),
          backgroundColor: AppTheme.brandBlack,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dbService = ref.read(databaseServiceProvider);

      await dbService.createListing(
        title: _titleController.text.trim(),
        category: _category,
        condition: _condition,
        price: double.parse(_priceController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        description: _descController.text.trim(),
        imageFiles: _selectedImages,
      );

      ref.invalidate(sellerProductsProvider);
      ref.invalidate(featuredProductsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Listing Added Successfully!',
              style: AppTheme.subHeader.copyWith(color: AppTheme.brandBlack),
            ),
            backgroundColor: AppTheme.brandYellow,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _stockController.dispose();
    super.dispose();
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
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
                      'ADD LISTING',
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
                  Text(
                    'Photo',
                    style: AppTheme.mainHeader.copyWith(
                      color: AppTheme.brandWhite,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ..._selectedImages.asMap().entries.map((entry) {
                          int index = entry.key;
                          XFile file = entry.value;
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: const BoxDecoration(
                                  color: AppTheme.brandWhite,
                                ),
                                child: kIsWeb
                                    ? Image.network(
                                        file.path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(file.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                top: 4,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.brandBlack.withOpacity(
                                        0.8,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: AppTheme.brandWhite,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 12),
                            color: AppTheme.brandWhite,
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 50,
                                color: AppTheme.brandBlack,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Listing Title'),
                  _buildTextField(_titleController),
                  _buildLabel('Price'),
                  _buildTextField(_priceController, isNumber: true),
                  _buildLabel('Quantity in Stock'),
                  _buildTextField(_stockController, isNumber: true),
                  _buildLabel('Category'),
                  _buildDropdown(
                    value: _category,
                    items: ['1:64', '1:43', '1:24', '1:18'],
                    onChanged: (val) => setState(() => _category = val!),
                  ),
                  _buildLabel('Condition'),
                  _buildDropdown(
                    value: _condition,
                    items: [
                      'Mint in Box',
                      'Loose Mint',
                      'Used/Played',
                      'Custom',
                    ],
                    onChanged: (val) => setState(() => _condition = val!),
                  ),
                  _buildLabel('Description (OPTIONAL)'),
                  _buildTextField(_descController, maxLines: 4),
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
                      onPressed: _isLoading ? null : _submitListing,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: AppTheme.brandBlack,
                            )
                          : Text(
                              'LIST ITEM',
                              style: AppTheme.subHeader.copyWith(
                                color: AppTheme.brandBlack,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
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

  Widget _buildTextField(
    TextEditingController controller, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
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

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      color: AppTheme.brandWhite,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppTheme.brandWhite,
          style: AppTheme.bodyText.copyWith(
            color: AppTheme.brandBlack,
            fontSize: 16,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.brandBlack,
          ),
          items: items
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

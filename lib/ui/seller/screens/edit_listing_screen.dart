import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../core/providers/products_provider.dart';
import '../../../models/product_model.dart';

class EditListingScreen extends ConsumerStatefulWidget {
  final Product product;

  const EditListingScreen({super.key, required this.product});

  @override
  ConsumerState<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends ConsumerState<EditListingScreen> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  late TextEditingController _stockController;

  late String _category;
  late String _condition;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _descController = TextEditingController(
      text: widget.product.description ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );

    final validCategories = ['1:64', '1:43', '1:24', '1:18'];
    _category = validCategories.contains(widget.product.category)
        ? widget.product.category
        : '1:64';

    final validConditions = [
      'Mint in Box',
      'Loose Mint',
      'Used/Played',
      'Custom',
    ];
    _condition = validConditions.contains(widget.product.condition)
        ? widget.product.condition
        : 'Mint in Box';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdates() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please provide a title and price.',
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
      await dbService.updateListing(
        productId: widget.product.id,
        title: _titleController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        description: _descController.text.trim(),
        category: _category,
        condition: _condition,
      );

      ref.invalidate(sellerProductsProvider);
      ref.invalidate(featuredProductsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Listing Updated Successfully!',
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
                      'EDIT LISTING',
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
                        ...widget.product.imageUrls.map((url) {
                          return Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: const BoxDecoration(
                              color: AppTheme.brandWhite,
                            ),
                            child: Image.network(url, fit: BoxFit.cover),
                          );
                        }),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(right: 12),
                          color: AppTheme.brandWhite,
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 50,
                              color: AppTheme.brandGrey,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          color: AppTheme.brandWhite,
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 50,
                              color: AppTheme.brandGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Text(
                      'TAP TO REPLACE (Currently disabled. Recreate listing to change photos)',
                      style: AppTheme.subHeader.copyWith(
                        color: AppTheme.brandGrey,
                        fontSize: 10,
                      ),
                    ),
                  ),
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
                      onPressed: _isLoading ? null : _submitUpdates,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: AppTheme.brandBlack,
                            )
                          : Text(
                              'SAVE',
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

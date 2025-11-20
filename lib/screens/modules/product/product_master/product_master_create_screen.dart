import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/productMasterBloc/productMaster_bloc.dart';
import '../../../../bloc/productMasterBloc/productMaster_event.dart';
import '../../../../bloc/productMasterBloc/productMaster_state.dart';
import '../../../../model/product_model.dart';
import '../../../../theme/app_theme.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _subCategoryController = TextEditingController();

  String _status = 'Active';
  String _isTaxable = 'Yes';
  String _isKeepingStock = 'Yes';
  final DateTime _savedIn = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    super.dispose();
  }

  void _saveProduct(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        productName: _nameController.text.trim(),
        type: _typeController.text.trim(),
        category: _categoryController.text.trim(),
        subCategory: _subCategoryController.text.trim().isEmpty ? null : _subCategoryController.text.trim(),
        isTaxable: _isTaxable,
        isKeepingStock: _isKeepingStock,
        savedIn: _savedIn,
        status: _status,
      );

      context.read<ProductBloc>().add(CreateProduct(product));
    }
  }

  void _resetForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Form?'),
        content: const Text('Are you sure you want to clear all fields?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _nameController.clear();
                _typeController.clear();
                _categoryController.clear();
                _subCategoryController.clear();
                _status = 'Active';
                _isTaxable = 'Yes';
                _isKeepingStock = 'Yes';
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Product created successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProductLoading;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Create New Product',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 5,
            actions: [
              IconButton(
                icon: const Icon(Icons.clear_all_rounded),
                tooltip: 'Clear Form',
                onPressed: isLoading ? null : _resetForm,
              ),
            ],
          ),
          body: Stack(
            children: [
              _buildBody(),
              if (isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, isLoading),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Basic Information', Icons.inventory_2_rounded),
            const SizedBox(height: 12),
            _buildBasicInformationSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Classification', Icons.category_rounded),
            const SizedBox(height: 12),
            _buildClassificationSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Product Settings', Icons.settings_rounded),
            const SizedBox(height: 12),
            _buildSettingsSection(),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryRetroModern.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primaryRetroModern,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryRetroModern,
              ),
        ),
      ],
    );
  }

  Widget _buildBasicInformationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Product Name',
              icon: Icons.inventory_2_rounded,
              validator: (value) => value?.isEmpty ?? true ? 'Product name is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _typeController,
              label: 'Type',
              icon: Icons.category_rounded,
              validator: (value) => value?.isEmpty ?? true ? 'Type is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _categoryController,
              label: 'Category',
              icon: Icons.folder_open_rounded,
              validator: (value) => value?.isEmpty ?? true ? 'Category is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _subCategoryController,
              label: 'Sub Category (Optional)',
              icon: Icons.subtitles_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdownField(
              value: _status,
              label: 'Status',
              icon: Icons.info_rounded,
              items: ['Active', 'Inactive'],
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              value: _isTaxable,
              label: 'Is Taxable',
              icon: Icons.currency_exchange_rounded,
              items: ['Yes', 'No'],
              onChanged: (value) => setState(() => _isTaxable = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              value: _isKeepingStock,
              label: 'Keeping Stock',
              icon: Icons.warehouse_rounded,
              items: ['Yes', 'No'],
              onChanged: (value) => setState(() => _isKeepingStock = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryRetroModern),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primaryRetroModern, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryRetroModern),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primaryRetroModern, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[50],
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : () => _saveProduct(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Create Product',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: AppTheme.primaryRetroModern,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
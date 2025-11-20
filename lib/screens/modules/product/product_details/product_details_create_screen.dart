import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/productDetailsBloc/productDetails_bloc.dart';
import '../../../../bloc/productDetailsBloc/productDetails_event.dart';
import '../../../../bloc/productDetailsBloc/productDetails_state.dart';
import '../../../../model/product_details_model.dart';
import '../../../../model/product_model.dart';
import '../../../../theme/app_theme.dart';

class CreateProductDetailsScreen extends StatefulWidget {
  final Product product;

  const CreateProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<CreateProductDetailsScreen> createState() => _CreateProductDetailsScreenState();
}

class _CreateProductDetailsScreenState extends State<CreateProductDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseUnitController = TextEditingController();
  final _derivedUnitController = TextEditingController();
  final _deriveFormulaController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _salesRateController = TextEditingController();
  final _fatRateController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _flavourController = TextEditingController();

  DateTime? _rateAffectsDate;
  DateTime? _stockDate;

  @override
  void dispose() {
    _baseUnitController.dispose();
    _derivedUnitController.dispose();
    _deriveFormulaController.dispose();
    _dimensionController.dispose();
    _salesRateController.dispose();
    _fatRateController.dispose();
    _openingStockController.dispose();
    _flavourController.dispose();
    super.dispose();
  }

  void _saveDetails(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final productDetails = ProductDetails(
        detailId: 0, // Will be set by database
        productId: widget.product.productId!,
        baseUnit: _baseUnitController.text.trim(),
        derivedUnit: _derivedUnitController.text.trim(),
        deriveFormula: _deriveFormulaController.text.trim(),
        dimension: _dimensionController.text.trim(),
        salesRate: double.parse(_salesRateController.text),
        fatRate: double.parse(_fatRateController.text),
        date: _rateAffectsDate,
        openingStock: double.parse(_openingStockController.text),
        stockDate: _stockDate,
        savedBy: 1, // Get from auth service
        savedIn: DateTime.now(),
        flavour: _flavourController.text.trim().isEmpty ? null : _flavourController.text.trim(),
        createdAt: null,
        updatedAt: null,
      );

      context.read<ProductDetailsBloc>().add(CreateProductDetails(productDetails));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {
        if (state is ProductDetailsCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Product details created successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
          // Return the created detail ID to navigate to detail screen
          Navigator.pop(context, state.productDetails.detailId);
        } else if (state is ProductDetailsError) {
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
        final isLoading = state is ProductDetailsLoading;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Add Details for ${widget.product.productName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 5,
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
            _buildProductInfoCard(),
            const SizedBox(height: 24),
            
            _buildSectionHeader('Unit Information', Icons.swap_horiz_rounded),
            const SizedBox(height: 12),
            _buildUnitInformationSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Pricing Information', Icons.attach_money_rounded),
            const SizedBox(height: 12),
            _buildPricingSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Stock Information', Icons.inventory_2_rounded),
            const SizedBox(height: 12),
            _buildStockSection(),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Additional Information', Icons.local_offer_rounded),
            const SizedBox(height: 12),
            _buildAdditionalSection(),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryRetroModern.withOpacity(0.1),
              AppTheme.primaryRetroModern.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRetroModern.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.inventory_2_rounded,
                    color: AppTheme.primaryRetroModern,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.productName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryRetroModern,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.product.category} • ${widget.product.type}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No details found for this product. Please add the required information below.',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildUnitInformationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _baseUnitController,
              label: 'Base Unit *',
              icon: Icons.straighten_rounded,
              hint: 'e.g., Liter, Kilogram',
              validator: (value) => value?.isEmpty ?? true ? 'Base unit is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _derivedUnitController,
              label: 'Derived Unit *',
              icon: Icons.compare_arrows_rounded,
              hint: 'e.g., Milliliter, Gram',
              validator: (value) => value?.isEmpty ?? true ? 'Derived unit is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _deriveFormulaController,
              label: 'Conversion Formula',
              icon: Icons.functions_rounded,
              hint: 'e.g., 1 Liter = 1000 ML',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _dimensionController,
              label: 'Dimension',
              icon: Icons.aspect_ratio_rounded,
              hint: 'e.g., Volume, Weight',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _salesRateController,
                    label: 'Sales Rate (Rs.) *',
                    icon: Icons.sell_rounded,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      if (double.tryParse(value!) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _fatRateController,
                    label: 'Fat Rate (Rs.) *',
                    icon: Icons.percent_rounded,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      if (double.tryParse(value!) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDatePicker(
              context: context,
              label: 'Rate Effective Date',
              icon: Icons.calendar_today_rounded,
              selectedDate: _rateAffectsDate,
              onDateSelected: (date) {
                setState(() => _rateAffectsDate = date);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _openingStockController,
              label: 'Opening Stock *',
              icon: Icons.warehouse_rounded,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                if (double.tryParse(value!) == null) return 'Invalid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildDatePicker(
              context: context,
              label: 'Stock Date',
              icon: Icons.event_rounded,
              selectedDate: _stockDate,
              onDateSelected: (date) {
                setState(() => _stockDate = date);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildTextField(
          controller: _flavourController,
          label: 'Flavour (Optional)',
          icon: Icons.emoji_food_beverage_rounded,
          hint: 'e.g., Vanilla, Chocolate',
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppTheme.primaryRetroModern,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[50],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryRetroModern),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedDate == null
                        ? 'Not set'
                        : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          ],
        ),
      ),
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
              onPressed: isLoading ? null : () => _saveDetails(context),
              icon: const Icon(Icons.save_rounded),
              label: const Text(
                'Create Details',
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
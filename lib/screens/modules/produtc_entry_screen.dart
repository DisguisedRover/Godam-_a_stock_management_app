import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/product_details_model.dart';
import '../../model/product_model.dart';
import '../../providers/product_provider.dart';
import '../../theme/app_theme.dart';

enum ProductType {
  rawMaterial,
  semiRawMaterial,
  packagingMaterial,
  finishedProduct,
}

enum Status { active, inactive }

class ProductEntryScreen extends StatefulWidget {
  const ProductEntryScreen({super.key});

  @override
  State<ProductEntryScreen> createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
  final _productFormKey = GlobalKey<FormState>();
  final _productDetailFormKey = GlobalKey<FormState>();

  final _productNameController = TextEditingController();
  final _unitConversionController = TextEditingController();
  final _salesRateController = TextEditingController();
  final _fatRateController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _stockValueController = TextEditingController();
  final _flavourController = TextEditingController();

  ProductType? _selectedProductType;
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedProduct;
  String? _selectedBaseUnit;
  String? _selectedDerivedUnit;
  bool _isTaxable = false;
  bool _isKeepingStock = true;
  Status _productStatus = Status.active;
  final String _rateAffectedFromDate = '2082-04-01';
  final String _stockDate = '2082-04-01';

  // Editing state
  String? _editingProductId;
  String? _editingProductDetailId;

  // Static lists
  final List<String> _categories = ['Category 1', 'Category 2'];
  final List<String> _subCategories = ['Sub Category 1', 'Sub Category 2'];
  final List<String> _products = [
    'MARIGOLD',
    'BUTTER',
    'DHUTO',
    'DANA MIXTURE',
  ];
  final List<String> _baseUnits = ['KG', 'Ltr', 'PCS'];
  final List<String> _derivedUnits = ['g', 'ml'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.fetchProducts();
    await provider.fetchProductDetails();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _unitConversionController.dispose();
    _salesRateController.dispose();
    _fatRateController.dispose();
    _openingStockController.dispose();
    _stockValueController.dispose();
    _flavourController.dispose();
    super.dispose();
  }

  void _clearProductForm() {
    _productFormKey.currentState?.reset();
    _productNameController.clear();
    setState(() {
      _selectedProductType = null;
      _selectedCategory = null;
      _selectedSubCategory = null;
      _isTaxable = false;
      _isKeepingStock = true;
      _productStatus = Status.active;
      _editingProductId = null;
    });
  }

  Future<void> _saveProductForm() async {
    if (_productFormKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      try {
        final productData = {
          'productName': _productNameController.text,
          'type': _selectedProductType.toString().split('.').last,
          'category': _selectedCategory,
          'subCategory': _selectedSubCategory,
          'isTaxable': _isTaxable,
          'isKeepingStock': _isKeepingStock,
          'status': _productStatus.toString().split('.').last,
          if (_editingProductId != null) 'productId': _editingProductId,
        };

        await provider.saveProduct(productData);

        if (!mounted) return;
        _showSnackBar(
          _editingProductId != null
              ? 'Product updated successfully!'
              : 'Product saved successfully!',
          Colors.green,
        );
        _clearProductForm();
      } catch (e) {
        if (!mounted) return;
        _showSnackBar('Error: ${e.toString()}', Colors.red);
      }
    }
  }

  void _clearProductDetailForm() {
    _productDetailFormKey.currentState?.reset();
    _unitConversionController.clear();
    _salesRateController.clear();
    _fatRateController.clear();
    _openingStockController.clear();
    _stockValueController.clear();
    _flavourController.clear();
    setState(() {
      _selectedProduct = null;
      _selectedBaseUnit = null;
      _selectedDerivedUnit = null;
      _editingProductDetailId = null;
    });
  }

  Future<void> _saveProductDetailForm() async {
    if (_productDetailFormKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      try {
        final detailData = {
          'productName': _selectedProduct,
          'baseUnit': _selectedBaseUnit,
          'derivedUnit': _selectedDerivedUnit,
          'unitConversionFormula': _unitConversionController.text,
          'salesRate': _salesRateController.text,
          'fatRate': _fatRateController.text,
          'rateAffectedFromDate': _rateAffectedFromDate,
          'openingStock': _openingStockController.text,
          'stockValue': _stockValueController.text,
          'stockDate': _stockDate,
          'flavour': _flavourController.text,
          if (_editingProductDetailId != null)
            'detailId': _editingProductDetailId,
        };

        await provider.saveProductDetail(detailData);

        if (!mounted) return;
        _showSnackBar(
          _editingProductDetailId != null
              ? 'Product detail updated successfully!'
              : 'Product detail saved successfully!',
          Colors.green,
        );
        _clearProductDetailForm();
      } catch (e) {
        if (!mounted) return;
        _showSnackBar('Error: ${e.toString()}', Colors.red);
      }
    }
  }

  void _editProduct(Product product) {
    setState(() {
      _productNameController.text = product.productName;
      _selectedProductType = ProductType.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toLowerCase() ==
            product.type.toLowerCase(),
        orElse: () => ProductType.finishedProduct,
      );
      _selectedCategory = product.category;
      _selectedSubCategory = product.subCategory;
      _isTaxable = product.isTaxable;
      _isKeepingStock = product.isKeepingStock;
      _productStatus = product.status.toLowerCase() == 'active'
          ? Status.active
          : Status.inactive;
      _editingProductId = product.productId;
    });
  }

  void _editProductDetail(ProductDetail detail) {
    setState(() {
      _selectedProduct = detail.productName;
      _selectedBaseUnit = detail.baseUnit;
      _selectedDerivedUnit = detail.derivedUnit;
      _unitConversionController.text = detail.deriveFormula ?? '';
      _salesRateController.text = detail.salesRate.toString();
      _fatRateController.text = detail.fatRate.toString();
      _openingStockController.text = detail.openingStock.toString();
      _stockValueController.text = detail.vpStock.toString();
      _flavourController.text = detail.flavour ?? '';
      _editingProductDetailId = detail.savedIn;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add logout logic here
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isProductListLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRetroModern,
              ),
            );
          }
          return _buildMainLayout(provider);
        },
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }

  Widget _buildMainLayout(ProductProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Panel - Forms (vertically scrollable)
          Flexible(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProductFormCard(),
                  const SizedBox(height: 16),
                  _buildProductDetailFormCard(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Right Panel - Tables (scrollable both ways)
          Flexible(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          _buildProductListCard(provider),
                          const SizedBox(height: 16),
                          _buildProductDetailListCard(provider),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductFormCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _productFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Entry',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fields with * are mandatory',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _productNameController,
                labelText: 'Product Name*',
                isRequired: true,
              ),
              _buildDropdownField<ProductType>(
                value: _selectedProductType,
                items: ProductType.values,
                labelText: 'Type*',
                isRequired: true,
                onChanged: (value) =>
                    setState(() => _selectedProductType = value),
                itemBuilder: (type) => type.toString().split('.').last,
              ),
              _buildDropdownField<String>(
                value: _selectedCategory,
                items: _categories,
                labelText: 'Category',
                onChanged: (value) => setState(() => _selectedCategory = value),
                itemBuilder: (category) => category,
              ),
              _buildDropdownField<String>(
                value: _selectedSubCategory,
                items: _subCategories,
                labelText: 'Sub Category',
                onChanged: (value) =>
                    setState(() => _selectedSubCategory = value),
                itemBuilder: (subCategory) => subCategory,
              ),
              SwitchListTile(
                title: const Text('Is Taxable Item'),
                value: _isTaxable,
                onChanged: (value) => setState(() => _isTaxable = value),
                activeColor: AppTheme.primaryRetroModern,
              ),
              SwitchListTile(
                title: const Text('Is Keeping Stock'),
                value: _isKeepingStock,
                onChanged: (value) => setState(() => _isKeepingStock = value),
                activeColor: AppTheme.primaryRetroModern,
              ),
              _buildDropdownField<Status>(
                value: _productStatus,
                items: Status.values,
                labelText: 'Status*',
                isRequired: true,
                onChanged: (value) => setState(() => _productStatus = value!),
                itemBuilder: (status) => status.toString().split('.').last,
              ),
              const SizedBox(height: 20),
              _buildFormButtons(
                onSave: _saveProductForm,
                onClear: _clearProductForm,
                isEditing: _editingProductId != null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetailFormCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _productDetailFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Detail Entry',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fields with * are mandatory',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdownField<String>(
                value: _selectedProduct,
                items: _products,
                labelText: 'Product*',
                isRequired: true,
                onChanged: (value) => setState(() => _selectedProduct = value),
                itemBuilder: (product) => product,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField<String>(
                      value: _selectedBaseUnit,
                      items: _baseUnits,
                      labelText: 'Base Unit*',
                      isRequired: true,
                      onChanged: (value) =>
                          setState(() => _selectedBaseUnit = value),
                      itemBuilder: (unit) => unit,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField<String>(
                      value: _selectedDerivedUnit,
                      items: _derivedUnits,
                      labelText: 'Derived Unit',
                      onChanged: (value) =>
                          setState(() => _selectedDerivedUnit = value),
                      itemBuilder: (unit) => unit,
                    ),
                  ),
                ],
              ),
              _buildTextField(
                controller: _unitConversionController,
                labelText: 'Unit Conversion Formula',
              ),
              _buildTextField(
                controller: _salesRateController,
                labelText: 'Sales Rate (Base Unit)',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _fatRateController,
                labelText: 'FAT % Rate',
                keyboardType: TextInputType.number,
              ),
              _buildReadOnlyField(
                labelText: 'Rate Affected From Date',
                value: _rateAffectedFromDate,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _openingStockController,
                      labelText: 'Opening Stock (Qty)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Unit Type: Base Unit'),
                ],
              ),
              _buildTextField(
                controller: _stockValueController,
                labelText: 'Stock Value (Rs)',
                keyboardType: TextInputType.number,
              ),
              _buildReadOnlyField(labelText: 'Stock Date', value: _stockDate),
              _buildTextField(
                controller: _flavourController,
                labelText: 'Flavour',
              ),
              const SizedBox(height: 20),
              _buildFormButtons(
                onSave: _saveProductDetailForm,
                onClear: _clearProductDetailForm,
                isEditing: _editingProductDetailId != null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductListCard(ProductProvider provider) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product List',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildTableControls(provider),
            const SizedBox(height: 16),
            _buildProductDataTable(provider),
            const SizedBox(height: 16),
            _buildPaginationControls(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailListCard(ProductProvider provider) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Detail List',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailTableControls(provider),
            const SizedBox(height: 16),
            _buildProductDetailDataTable(provider),
            const SizedBox(height: 16),
            _buildDetailPaginationControls(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildTableControls(ProductProvider provider) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: _buildDropdownField<ProductType>(
            value: null,
            items: ProductType.values,
            labelText: 'Filter by Type',
            onChanged: (value) {
              provider.filterProducts(type: value?.toString().split('.').last);
            },
            itemBuilder: (type) => type.toString().split('.').last,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 180,
          child: _buildDropdownField<Status>(
            value: null,
            items: Status.values,
            labelText: 'Filter by Status',
            onChanged: (value) {
              provider.filterProducts(
                status: value?.toString().split('.').last,
              );
            },
            itemBuilder: (status) => status.toString().split('.').last,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            onPressed: () => provider.fetchProducts(),
            icon: const Icon(Icons.search, size: 20),
            label: const Text('Search', style: TextStyle(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRetroModern,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(
            onPressed: () =>
                _showSnackBar('Export to Excel pressed...', Colors.blue),
            icon: const Icon(Icons.upload_file, size: 20),
            label: const Text('Export', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryRetroModern),
              foregroundColor: AppTheme.primaryRetroModern,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTableControls(ProductProvider provider) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: _buildDropdownField<String>(
            value: null,
            items: _products,
            labelText: 'Filter by Product',
            onChanged: (value) {
              provider.filterProductDetails(name: value);
            },
            itemBuilder: (product) => product,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 180,
          child: _buildDropdownField<Status>(
            value: null,
            items: Status.values,
            labelText: 'Filter by Status',
            onChanged: (value) {
              provider.filterProductDetails(
                status: value?.toString().split('.').last,
              );
            },
            itemBuilder: (status) => status.toString().split('.').last,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            onPressed: () => provider.fetchProductDetails(),
            icon: const Icon(Icons.search, size: 20),
            label: const Text('Search', style: TextStyle(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRetroModern,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDataTable(ProductProvider provider) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final products = provider.filteredProducts.isNotEmpty
        ? provider.filteredProducts
        : provider.products;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        headingRowColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => AppTheme.primaryRetroModern.withOpacity(0.1),
        ),
        dataRowColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => isDarkMode ? AppTheme.darkCardBackground : Colors.white,
        ),
        columnSpacing: 24,
        horizontalMargin: 16,
        columns: [
          DataColumn(label: Text('ID', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('Name', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('Type', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('Category', style: _boldColumnStyle(theme))),
          DataColumn(
            label: Text('Sub Category', style: _boldColumnStyle(theme)),
          ),
          DataColumn(label: Text('Taxable', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('Stock', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('Status', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('Actions', style: _boldColumnStyle(theme))),
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(Text(product.productId)),
              DataCell(Text(product.productName)),
              DataCell(Text(product.type)),
              DataCell(Text(product.category ?? '-')),
              DataCell(Text(product.subCategory ?? '-')),
              DataCell(Text(product.isTaxable ? 'Yes' : 'No')),
              DataCell(Text(product.isKeepingStock ? 'Yes' : 'No')),
              DataCell(
                Chip(
                  label: Text(
                    product.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: product.status.toLowerCase() == 'active'
                      ? Colors.green
                      : Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editProduct(product),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductDetailDataTable(ProductProvider provider) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final details = provider.filteredProductDetails.isNotEmpty
        ? provider.filteredProductDetails
        : provider.productDetails;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        headingRowColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => AppTheme.primaryRetroModern.withOpacity(0.1),
        ),
        dataRowColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => isDarkMode ? AppTheme.darkCardBackground : Colors.white,
        ),
        columnSpacing: 24,
        horizontalMargin: 16,
        columns: [
          DataColumn(label: Text('Product', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('Base Unit', style: _boldColumnStyle(theme))),
          DataColumn(
            label: Text('Derived Unit', style: _boldColumnStyle(theme)),
          ),
          DataColumn(label: Text('Sales Rate', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('FAT Rate', style: _boldColumnStyle(theme))),
          DataColumn(
            label: Text('Opening Stock', style: _boldColumnStyle(theme)),
          ),
          DataColumn(label: Text('Status', style: _boldColumnStyle(theme))),
          DataColumn(label: Text('Actions', style: _boldColumnStyle(theme))),
        ],
        rows: details.map((detail) {
          return DataRow(
            cells: [
              DataCell(Text(detail.productName)),
              DataCell(Text(detail.baseUnit)),
              DataCell(Text(detail.derivedUnit ?? '')),
              DataCell(Text(detail.salesRate.toStringAsFixed(2))),
              DataCell(Text(detail.fatRate.toStringAsFixed(2))),
              DataCell(Text(detail.openingStock.toStringAsFixed(2))),
              DataCell(
                Chip(
                  label: Text(
                    detail.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: detail.status.toLowerCase() == 'active'
                      ? Colors.green
                      : Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editProductDetail(detail),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  TextStyle _boldColumnStyle(ThemeData theme) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  Widget _buildPaginationControls(ProductProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Displaying 1 to ${provider.products.length} of ${provider.products.length} items',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Row(
          children: [
            IconButton(
              onPressed: provider.currentProductPage == 1
                  ? null
                  : () => provider.goToFirstProductPage(),
              icon: Icon(
                Icons.first_page,
                color: provider.currentProductPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed: provider.currentProductPage == 1
                  ? null
                  : () => provider.goToPreviousProductPage(),
              icon: Icon(
                Icons.chevron_left,
                color: provider.currentProductPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Page ${provider.currentProductPage} of ${provider.totalProductPages}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed:
                  provider.currentProductPage == provider.totalProductPages
                  ? null
                  : () => provider.goToNextProductPage(),
              icon: Icon(
                Icons.chevron_right,
                color: provider.currentProductPage == provider.totalProductPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed:
                  provider.currentProductPage == provider.totalProductPages
                  ? null
                  : () => provider.goToLastProductPage(),
              icon: Icon(
                Icons.last_page,
                color: provider.currentProductPage == provider.totalProductPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailPaginationControls(ProductProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Displaying 1 to ${provider.productDetails.length} of ${provider.productDetails.length} items',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Row(
          children: [
            IconButton(
              onPressed: provider.currentDetailPage == 1
                  ? null
                  : () => provider.goToFirstDetailPage(),
              icon: Icon(
                Icons.first_page,
                color: provider.currentDetailPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed: provider.currentDetailPage == 1
                  ? null
                  : () => provider.goToPreviousDetailPage(),
              icon: Icon(
                Icons.chevron_left,
                color: provider.currentDetailPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Page ${provider.currentDetailPage} of ${provider.totalProductDetailPages}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed:
                  provider.currentDetailPage == provider.totalProductDetailPages
                  ? null
                  : () => provider.goToNextDetailPage(),
              icon: Icon(
                Icons.chevron_right,
                color:
                    provider.currentDetailPage ==
                        provider.totalProductDetailPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed:
                  provider.currentDetailPage == provider.totalProductDetailPages
                  ? null
                  : () => provider.goToLastDetailPage(),
              icon: Icon(
                Icons.last_page,
                color:
                    provider.currentDetailPage ==
                        provider.totalProductDetailPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: labelText,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(
              color: AppTheme.primaryRetroModern,
              width: 2,
            ),
          ),
          errorBorder: border.copyWith(
            borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
          ),
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          floatingLabelStyle: TextStyle(color: AppTheme.primaryRetroModern),
        ),
        validator: isRequired
            ? (value) =>
                  value?.isEmpty ?? true ? '$labelText is required' : null
            : null,
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String labelText,
    required String value,
  }) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(
              color: AppTheme.primaryRetroModern,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          floatingLabelStyle: TextStyle(color: AppTheme.primaryRetroModern),
        ),
        child: Text(
          value,
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required List<T> items,
    required String labelText,
    bool isRequired = false,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemBuilder,
  }) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: labelText,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(
              color: AppTheme.primaryRetroModern,
              width: 2,
            ),
          ),
          errorBorder: border.copyWith(
            borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
          ),
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          floatingLabelStyle: TextStyle(color: AppTheme.primaryRetroModern),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemBuilder(item),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: isRequired
            ? (value) => value == null ? '$labelText is required' : null
            : null,
        dropdownColor: theme.cardTheme.color,
        icon: Icon(
          Icons.arrow_drop_down,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildFormButtons({
    required VoidCallback onSave,
    required VoidCallback onClear,
    bool isEditing = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRetroModern,
              minimumSize: const Size.fromHeight(50),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              isEditing ? 'Update' : 'Save',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: onClear,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: BorderSide(color: AppTheme.primaryRetroModern),
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.primaryRetroModern,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Copyright © 2025'),
          const Text('Economic Year: 2082/2083'),
          const Text('License To: CMP Trade Concern'),
        ],
      ),
    );
  }
}

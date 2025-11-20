import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milk_content_analysis/bloc/productDetailsBloc/productDetails_event.dart';

import '../../../../bloc/productDetailsBloc/productDetails_bloc.dart';
import '../../../../bloc/productDetailsBloc/productDetails_state.dart';
import '../../../../model/product_details_model.dart';
import '../../../../utils/auth_guard.dart';

class ProductDetailsListScreen extends StatefulWidget {
  const ProductDetailsListScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsListScreen> createState() => _ProductDetailsListScreenState();
}

class _ProductDetailsListScreenState extends State<ProductDetailsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
     WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkAuthentication();
  });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  Future<void> _checkAuthentication() async {
  await AuthGuard.checkAuth(context);
  } 

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc()..add(LoadProductDetails()),
      child: Scaffold(
        body: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
          listener: (context, state) {
            if (state is ProductDetailsError) {
              _showSnackBar(context, state.message, Colors.red);
            } else if (state is ProductDetailsUpdated) {
              _showSnackBar(context, 'Product Details updated successfully', Colors.green);
              context.read<ProductDetailsBloc>().add(LoadProductDetails());
            } else if (state is ProductDetailsCreated) {
              _showSnackBar(context, 'Product Details created successfully', Colors.green);
              context.read<ProductDetailsBloc>().add(LoadProductDetails());
            } else if (state is ProductDetailsDeleted) {
              _showSnackBar(context, 'Product Details deleted successfully', Colors.green);
              context.read<ProductDetailsBloc>().add(LoadProductDetails());
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                if (state is ProductDetailsLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is ProductDetailsLoaded)
                  _buildProductDetailsList(context, state.productDetails, _searchQuery)
                else if (state is ProductDetailsError)
                  SliverFillRemaining(child: _buildErrorWidget(context, state.message))
                else
                  const SliverFillRemaining(
                    child: Center(child: Text('Start managing your product details')),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton.extended(
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Product Details'),
              onPressed: () => _showCreateProductDetailsSheet(context),
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text('Product Details'),
      floating: true,
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search product details...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetailsList(
      BuildContext context, List<ProductDetails> productDetails, String query) {
    final filteredProductDetails = productDetails.where((productDetail) {
      return productDetail.baseUnit.toLowerCase().contains(query) ||
          productDetail.derivedUnit.toLowerCase().contains(query) ||
          productDetail.dimension.toLowerCase().contains(query) ||
          (productDetail.flavour?.toLowerCase().contains(query) ?? false) ||
          productDetail.salesRate.toString().contains(query);
    }).toList();

    if (filteredProductDetails.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
              query.isEmpty ? 'No product details found' : 'No product details match "$query"'),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _ProductDetailListItem(
            key: ValueKey(filteredProductDetails[index].detailId), 
            productDetails: filteredProductDetails[index],
          );
        },
        childCount: filteredProductDetails.length,
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $message', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<ProductDetailsBloc>().add(LoadProductDetails());
            },
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _showCreateProductDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<ProductDetailsBloc>(context),
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: const _CreateProductDetailsSheet(),
        ),
      ),
    );
  }
}

class _ProductDetailListItem extends StatelessWidget {
  final ProductDetails productDetails;

  const _ProductDetailListItem({required this.productDetails, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    String formatDate(DateTime? date) {
      if (date == null) return 'Not set';
      return '${date.day}/${date.month}/${date.year}';
    }

    String formatCurrency(double value) {
      return '₹${value.toStringAsFixed(2)}';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${productDetails.baseUnit} → ${productDetails.derivedUnit}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (productDetails.flavour != null && productDetails.flavour!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      productDetails.flavour!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Formula and Dimension
            if (productDetails.deriveFormula.isNotEmpty)
              Text(
                'Formula: ${productDetails.deriveFormula}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
              ),
            if (productDetails.dimension.isNotEmpty)
              Text(
                'Dimension: ${productDetails.dimension}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            
            const Divider(height: 16),
            
            // Rates and Stock Information
            _buildInfoRow(context, Icons.attach_money_rounded, 'Sales Rate', formatCurrency(productDetails.salesRate)),
            _buildInfoRow(context, Icons.percent_rounded, 'Fat Rate', formatCurrency(productDetails.fatRate)),
            _buildInfoRow(context, Icons.inventory_2_rounded, 'Opening Stock', productDetails.openingStock.toString()),
            
            // Dates
            if (productDetails.date != null)
              _buildInfoRow(context, Icons.calendar_today_rounded, 'Rate Date', formatDate(productDetails.date)),
            if (productDetails.stockDate != null)
              _buildInfoRow(context, Icons.calendar_today_rounded, 'Stock Date', formatDate(productDetails.stockDate)),
            
            const SizedBox(height: 10),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  context,
                  Icons.edit_rounded,
                  'Edit',
                  colorScheme.secondary,
                  () => _showEditProductDetailsSheet(context, productDetails), 
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  context,
                  Icons.delete_rounded,
                  'Delete',
                  colorScheme.error,
                  () => _showDeleteConfirmation(context, productDetails),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProductDetails productDetails) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to permanently delete product details for **${productDetails.baseUnit} → ${productDetails.derivedUnit}**?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductDetailsBloc>().add(
                    DeleteProductDetails(productDetails.detailId),
                  );
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

void _showEditProductDetailsSheet(BuildContext context, ProductDetails productDetails) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (dialogContext) => BlocProvider.value(
      value: BlocProvider.of<ProductDetailsBloc>(context),
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
        ),
        child: _EditProductDetailsSheet(productDetails: productDetails),
      ),
    ),
  );
}

class _CreateProductDetailsSheet extends StatefulWidget {
  const _CreateProductDetailsSheet();

  @override
  State<_CreateProductDetailsSheet> createState() => _CreateProductDetailsSheetState();
}

class _CreateProductDetailsSheetState extends State<_CreateProductDetailsSheet> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
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
    _productIdController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create New Product Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _productIdController,
                    decoration: const InputDecoration(
                      labelText: 'Product ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Product ID is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _baseUnitController,
                    decoration: const InputDecoration(
                      labelText: 'Base Unit',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Base unit is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _derivedUnitController,
                    decoration: const InputDecoration(
                      labelText: 'Derived Unit',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Derived unit is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _deriveFormulaController,
                    decoration: const InputDecoration(
                      labelText: 'Derive Formula',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dimensionController,
                    decoration: const InputDecoration(
                      labelText: 'Dimension',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _salesRateController,
                          decoration: const InputDecoration(
                            labelText: 'Sales Rate',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value?.isEmpty ?? true ? 'Sales rate is required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _fatRateController,
                          decoration: const InputDecoration(
                            labelText: 'Fat Rate',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value?.isEmpty ?? true ? 'Fat rate is required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _openingStockController,
                    decoration: const InputDecoration(
                      labelText: 'Opening Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value?.isEmpty ?? true ? 'Opening stock is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _flavourController,
                    decoration: const InputDecoration(
                      labelText: 'Flavour',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(_rateAffectsDate == null 
                              ? 'Select Rate Date' 
                              : 'Rate Date: ${_rateAffectsDate!.day}/${_rateAffectsDate!.month}/${_rateAffectsDate!.year}'),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() => _rateAffectsDate = date);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ListTile(
                          title: Text(_stockDate == null 
                              ? 'Select Stock Date' 
                              : 'Stock Date: ${_stockDate!.day}/${_stockDate!.month}/${_stockDate!.year}'),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() => _stockDate = date);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        // Action Buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ButtonBar(
            buttonPadding: EdgeInsets.zero,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final productDetails = ProductDetails(
                      detailId: 0, // Will be set by database
                      productId: int.parse(_productIdController.text),
                      baseUnit: _baseUnitController.text,
                      derivedUnit: _derivedUnitController.text,
                      deriveFormula: _deriveFormulaController.text,
                      dimension: _dimensionController.text,
                      salesRate: double.parse(_salesRateController.text),
                      fatRate: double.parse(_fatRateController.text),
                      date: _rateAffectsDate,
                      openingStock: double.parse(_openingStockController.text),
                      stockDate: _stockDate,
                      savedBy: 1, // Current user ID
                      savedIn: DateTime.now(),
                      flavour: _flavourController.text.isEmpty ? null : _flavourController.text,
                      createdAt: null,
                      updatedAt: null,
                    );

                    context.read<ProductDetailsBloc>().add(CreateProductDetails(productDetails));
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Create'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditProductDetailsSheet extends StatefulWidget {
  final ProductDetails productDetails;

  const _EditProductDetailsSheet({required this.productDetails});

  @override
  State<_EditProductDetailsSheet> createState() => _EditProductDetailsSheetState();
}

class _EditProductDetailsSheetState extends State<_EditProductDetailsSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _baseUnitController;
  late final TextEditingController _derivedUnitController;
  late final TextEditingController _deriveFormulaController;
  late final TextEditingController _dimensionController;
  late final TextEditingController _salesRateController;
  late final TextEditingController _fatRateController;
  late final TextEditingController _openingStockController;
  late final TextEditingController _flavourController;

  late DateTime? _rateAffectsDate;
  late DateTime? _stockDate;

  @override
  void initState() {
    super.initState();
    _baseUnitController = TextEditingController(text: widget.productDetails.baseUnit);
    _derivedUnitController = TextEditingController(text: widget.productDetails.derivedUnit);
    _deriveFormulaController = TextEditingController(text: widget.productDetails.deriveFormula);
    _dimensionController = TextEditingController(text: widget.productDetails.dimension);
    _salesRateController = TextEditingController(text: widget.productDetails.salesRate.toString());
    _fatRateController = TextEditingController(text: widget.productDetails.fatRate.toString());
    _openingStockController = TextEditingController(text: widget.productDetails.openingStock.toString());
    _flavourController = TextEditingController(text: widget.productDetails.flavour ?? '');
    
    _rateAffectsDate = widget.productDetails.date;
    _stockDate = widget.productDetails.stockDate;
  }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit ${widget.productDetails.baseUnit} → ${widget.productDetails.derivedUnit}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _baseUnitController,
                    decoration: const InputDecoration(
                      labelText: 'Base Unit',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _derivedUnitController,
                    decoration: const InputDecoration(
                      labelText: 'Derived Unit',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _deriveFormulaController,
                    decoration: const InputDecoration(
                      labelText: 'Derive Formula',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dimensionController,
                    decoration: const InputDecoration(
                      labelText: 'Dimension',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _salesRateController,
                          decoration: const InputDecoration(
                            labelText: 'Sales Rate',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _fatRateController,
                          decoration: const InputDecoration(
                            labelText: 'Fat Rate',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _openingStockController,
                    decoration: const InputDecoration(
                      labelText: 'Opening Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _flavourController,
                    decoration: const InputDecoration(
                      labelText: 'Flavour',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(_rateAffectsDate == null 
                              ? 'Select Rate Date' 
                              : 'Rate Date: ${_rateAffectsDate!.day}/${_rateAffectsDate!.month}/${_rateAffectsDate!.year}'),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _rateAffectsDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() => _rateAffectsDate = date);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ListTile(
                          title: Text(_stockDate == null 
                              ? 'Select Stock Date' 
                              : 'Stock Date: ${_stockDate!.day}/${_stockDate!.month}/${_stockDate!.year}'),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _stockDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() => _stockDate = date);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        // Action Buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedProductDetails = ProductDetails(
                      detailId: widget.productDetails.detailId,
                      productId: widget.productDetails.productId,
                      baseUnit: _baseUnitController.text,
                      derivedUnit: _derivedUnitController.text,
                      deriveFormula: _deriveFormulaController.text,
                      dimension: _dimensionController.text,
                      salesRate: double.parse(_salesRateController.text),
                      fatRate: double.parse(_fatRateController.text),
                      date: _rateAffectsDate,
                      openingStock: double.parse(_openingStockController.text),
                      stockDate: _stockDate,
                      savedBy: widget.productDetails.savedBy,
                      savedIn: widget.productDetails.savedIn,
                      flavour: _flavourController.text.isEmpty ? null : _flavourController.text,
                      createdAt: widget.productDetails.createdAt,
                      updatedAt: DateTime.now(),
                    );

                    context.read<ProductDetailsBloc>().add(
                          UpdateProductDetails(
                            widget.productDetails.detailId,
                            updatedProductDetails,
                          ),
                        );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Update'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
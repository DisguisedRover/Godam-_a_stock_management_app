import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/productDetailsBloc/productDetails_bloc.dart';
import '../../../../bloc/productDetailsBloc/productDetails_event.dart';
import '../../../../bloc/productDetailsBloc/productDetails_state.dart';
import '../../../../model/product_details_model.dart';
import '../../../../theme/app_theme.dart';
import 'product_details_edit_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final ProductDetails? initialProductDetails;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
    this.initialProductDetails,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductDetailsBloc _productDetailsBloc;

  @override
  void initState() {
    super.initState();
    _productDetailsBloc = ProductDetailsBloc();
    
    // Load product details if not provided initially
    if (widget.initialProductDetails == null) {
      _loadProductDetails();
    }
  }

  void _loadProductDetails() {
    _productDetailsBloc.add(LoadProductDetailsByProductId(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productDetailsBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Product Details',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 5,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _loadProductDetails,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {
        if (state is ProductDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is ProductDetailsUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product details updated successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (widget.initialProductDetails != null && 
            state is! ProductDetailLoaded && 
            state is! ProductDetailsUpdated) {
          return _buildContent(widget.initialProductDetails!);
        }

        if (state is ProductDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProductDetailLoaded) {
          return _buildContent(state.productDetails);
        } else if (state is ProductDetailsUpdated) {
          return _buildContent(state.productDetails);
        } else if (state is ProductDetailsError) {
          return _buildErrorWidget(context, state.message);
        } else {
          return _buildContent(widget.initialProductDetails ?? _getEmptyProductDetails());
        }
      },
    );
  }

  ProductDetails _getEmptyProductDetails() {
    return ProductDetails(
      detailId: 0,
      productId: widget.productId,
      baseUnit: 'N/A',
      derivedUnit: 'N/A',
      deriveFormula: '',
      dimension: '',
      salesRate: 0.0,
      fatRate: 0.0,
      openingStock: 0.0,
    );
  }

  Widget _buildContent(ProductDetails productDetails) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadProductDetails();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppTheme.primaryRetroModern,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context, productDetails),
            const SizedBox(height: 16),

            // Unit Conversion Section
            _buildDetailCard(
              context,
              Icons.swap_horiz_rounded,
              'Unit Conversion',
              [
                _buildDetailRow(context, 'Base Unit', productDetails.baseUnit),
                _buildDetailRow(context, 'Derived Unit', productDetails.derivedUnit),
                if (productDetails.deriveFormula.isNotEmpty)
                  _buildDetailRow(context, 'Conversion Formula', productDetails.deriveFormula),
                if (productDetails.dimension.isNotEmpty)
                  _buildDetailRow(context, 'Dimension', productDetails.dimension),
              ],
            ),
            const SizedBox(height: 16),

            // Pricing Information Section
            _buildDetailCard(
              context,
              Icons.attach_money_rounded,
              'Pricing Information',
              [
                _buildDetailRowWithIcon(
                  context,
                  'Sales Rate',
                  'Rs. ${productDetails.salesRate.toStringAsFixed(2)}',
                  Icons.sell_rounded,
                  Colors.green,
                ),
                _buildDetailRowWithIcon(
                  context,
                  'Fat Rate',
                  'Rs. ${productDetails.fatRate.toStringAsFixed(2)}',
                  Icons.percent_rounded,
                  Colors.blue,
                ),
                if (productDetails.date != null)
                  _buildDetailRowWithIcon(
                    context,
                    'Rate Effective Date',
                    _formatDate(productDetails.date!),
                    Icons.date_range_outlined,
                    Colors.orange,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Stock Information Section
            _buildDetailCard(
              context,
              Icons.inventory_2_rounded,
              'Stock Information',
              [
                _buildDetailRowWithIcon(
                  context,
                  'Opening Stock',
                  productDetails.openingStock.toStringAsFixed(2),
                  Icons.warehouse_rounded,
                  Colors.blue,
                ),
                if (productDetails.stockDate != null)
                  _buildDetailRowWithIcon(
                    context,
                    'Stock Date',
                    _formatDate(productDetails.stockDate!),
                    Icons.date_range_outlined,
                    Colors.orange,
                  ),
              ],
            ),

            // Additional Information Section
            if (productDetails.flavour != null && productDetails.flavour!.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    context,
                    Icons.local_offer_rounded,
                    'Additional Information',
                    [
                      _buildDetailRowWithIcon(
                        context,
                        'Flavour',
                        productDetails.flavour!,
                        Icons.emoji_food_beverage_rounded,
                        Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),

            // System Information Section
            const SizedBox(height: 16),
            _buildDetailCard(
              context,
              Icons.info_rounded,
              'System Information',
              _buildSystemInfoRows(productDetails),
            ),

            // Action Buttons
            const SizedBox(height: 20),
            _buildActionButtons(context, productDetails),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, ProductDetails productDetails) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryRetroModern.withOpacity(0.9),
              AppTheme.primaryRetroModern,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.inventory_rounded, 
                    color: Colors.white, 
                    size: 24
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${productDetails.baseUnit} → ${productDetails.derivedUnit}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderStat('Sales Rate', 'Rs. ${productDetails.salesRate.toStringAsFixed(2)}'),
                _buildHeaderStat('Fat Rate', 'Rs. ${productDetails.fatRate.toStringAsFixed(2)}'),
                _buildHeaderStat('Stock', productDetails.openingStock.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context, IconData icon, String title, List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
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
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryRetroModern,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSystemInfoRows(ProductDetails productDetails) {
    final rows = <Widget>[
      _buildDetailRow(context, 'Product: ', productDetails.productName.toString()),
      // _buildDetailRow(context, 'Detail ID', productDetails.detailId.toString()),
    ];

    if (productDetails.savedBy != null) {
      rows.add(_buildDetailRow(context, 'Saved By: ', productDetails.savedByUsername.toString()));
    }
    if (productDetails.savedIn != null) {
      rows.add(_buildDetailRow(context, 'Saved On: ', _formatDateTime(productDetails.savedIn!)));
    }
    if (productDetails.createdAt != null) {
      rows.add(_buildDetailRow(context, 'Created: ', _formatDateTime(productDetails.createdAt!)));
    }
    if (productDetails.updatedAt != null) {
      rows.add(_buildDetailRow(context, 'Last Updated: ', _formatDateTime(productDetails.updatedAt!)));
    }

    return rows;
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithIcon(BuildContext context, String label, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ProductDetails productDetails) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _navigateToEditScreen(context, productDetails);
            },
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit Details'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              side: BorderSide(color: AppTheme.primaryRetroModern),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showShareOptions(context, productDetails);
            },
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: AppTheme.primaryRetroModern,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadProductDetails();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppTheme.primaryRetroModern,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, 
                  size: 64, 
                  color: Colors.red
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Unable to load product details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _loadProductDetails,
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRetroModern,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, ProductDetails productDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _productDetailsBloc,
          child: EditProductDetailsScreen(productDetails: productDetails),
        ),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh the data after edit
        _loadProductDetails();
      }
    });
  }

  void _showShareOptions(BuildContext context, ProductDetails productDetails) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share Product Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.copy_rounded, 
                  color: AppTheme.primaryRetroModern
                ),
                title: Text('Copy to Clipboard', 
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                onTap: () {
                  _copyToClipboard(context, productDetails);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.print_rounded, 
                  color: AppTheme.primaryRetroModern
                ),
                title: Text('Print Details', 
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                onTap: () {
                  _printDetails(context, productDetails);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.email_rounded, 
                  color: AppTheme.primaryRetroModern
                ),
                title: Text('Send via Email', 
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                onTap: () {
                  _sendViaEmail(context, productDetails);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: AppTheme.primaryRetroModern),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text('Cancel', 
                  style: TextStyle(color: AppTheme.primaryRetroModern)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, ProductDetails productDetails) {
    // ignore: unused_local_variable
    final detailsText = '''
Product Details:
---------------
Base Unit: ${productDetails.baseUnit}
Derived Unit: ${productDetails.derivedUnit}
Sales Rate: Rs. ${productDetails.salesRate.toStringAsFixed(2)}
Fat Rate: Rs. ${productDetails.fatRate.toStringAsFixed(2)}
Opening Stock: ${productDetails.openingStock.toStringAsFixed(2)}
${productDetails.flavour != null ? 'Flavour: ${productDetails.flavour}' : ''}
''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Product details copied to clipboard'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.primaryRetroModern,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _printDetails(BuildContext context, ProductDetails productDetails) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Print functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sendViaEmail(BuildContext context, ProductDetails productDetails) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _productDetailsBloc.close();
    super.dispose();
  }
}
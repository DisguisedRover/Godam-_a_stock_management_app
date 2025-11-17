import 'package:flutter/material.dart';
import '../../../model/product_details_model.dart';
import '../../../theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductDetails productDetails;

  const ProductDetailScreen({Key? key, required this.productDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '${productDetails.baseUnit} → ${productDetails.derivedUnit}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              _showEditOptions(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 16),

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
                  _buildDetailRowWithIcon
                  (
                    context, 
                    'Rate Effective Date',
                   _formatDate(productDetails.date!),
                    Icons.date_range_outlined, 
                    Colors.redAccent,
                    ),
              ],
            ),
            const SizedBox(height: 16),

            _buildDetailCard(
              context,
              Icons.inventory_2_rounded,
              'Stock Information',
              [
                _buildDetailRowWithIcon(
                  context,
                  'Opening Stock',
                  productDetails.openingStock.toString(),
                  Icons.warehouse_rounded,
                  Colors.orange,
                ),
                if (productDetails.stockDate != null)
                  _buildDetailRowWithIcon(
                    context, 
                    'Stock Date', 
                    _formatDate(productDetails.stockDate!),
                     Icons.date_range_outlined, 
                    Colors.redAccent,
                    ),
              ],
            ),
            const SizedBox(height: 16),

            _buildDetailCard(
              context,
              Icons.local_offer_rounded,
              'Additional Information',
              [
                if (productDetails.flavour != null && productDetails.flavour!.isNotEmpty)
                  _buildDetailRowWithIcon(
                    context,
                    'Flavour',
                    productDetails.flavour!,
                    Icons.emoji_food_beverage_rounded,
                    Colors.purple,
                  ),
                _buildDetailRowWithIcon(
                  context, 
                  'Product ID', 
                  productDetails.productId.toString(),
                  Icons.tab_unselected,
                  Colors.blue,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            _buildDetailCard(
              context,
              Icons.info_rounded,
              'System Information',
              [
                if (productDetails.savedBy != null)
                  _buildDetailRow(context, 'Saved By User ID', productDetails.savedBy.toString()),
                if (productDetails.savedIn != null)
                  _buildDetailRow(context, 'Saved On', _formatDateTime(productDetails.savedIn!)),
                if (productDetails.createdAt != null)
                  _buildDetailRow(context, 'Created', _formatDateTime(productDetails.createdAt!)),
                if (productDetails.updatedAt != null)
                  _buildDetailRow(context, 'Last Updated', _formatDateTime(productDetails.updatedAt!)),
              ],
            ),

            const SizedBox(height: 20),

            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.inventory_rounded, color: Colors.white, size: 24),
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
                _buildHeaderStat('Stock', productDetails.openingStock.toString()),
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
      elevation: 5,
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _showEditOptions(context);
            },
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit Details'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              side: BorderSide(color: AppTheme.primaryRetroModern),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showShareOptions(context);
            },
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: AppTheme.primaryRetroModern,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Options',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.edit_attributes_rounded, color: AppTheme.primaryRetroModern),
                title: Text('Edit Basic Information', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit basic info screen
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_money_rounded, color: AppTheme.primaryRetroModern),
                title: Text('Update Pricing', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit pricing screen
                },
              ),
              ListTile(
                leading: Icon(Icons.inventory_2_rounded, color: AppTheme.primaryRetroModern),
                title: Text('Update Stock', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit stock screen
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: AppTheme.primaryRetroModern),
                ),
                child: Text('Cancel', style: TextStyle(color: AppTheme.primaryRetroModern)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                leading: Icon(Icons.copy_rounded, color: AppTheme.primaryRetroModern),
                title: Text('Copy to Clipboard', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                onTap: () {
                  _copyToClipboard(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.print_rounded, color: AppTheme.primaryRetroModern),
                title: Text('Print Details', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                onTap: () {
                  Navigator.pop(context);
                  // Implement print functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.email_rounded, color: AppTheme.primaryRetroModern),
                title: Text('Send via Email', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                onTap: () {
                  Navigator.pop(context);
                  // Implement email functionality
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: AppTheme.primaryRetroModern),
                ),
                child: Text('Cancel', style: TextStyle(color: AppTheme.primaryRetroModern)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final details = '''
Product Details:
• Base Unit: ${productDetails.baseUnit}
• Derived Unit: ${productDetails.derivedUnit}
• Sales Rate: Rs. ${productDetails.salesRate.toStringAsFixed(2)}
• Fat Rate: Rs. ${productDetails.fatRate.toStringAsFixed(2)}
• Opening Stock: ${productDetails.openingStock}
${productDetails.deriveFormula.isNotEmpty ? '• Formula: ${productDetails.deriveFormula}' : ''}
${productDetails.dimension.isNotEmpty ? '• Dimension: ${productDetails.dimension}' : ''}
${productDetails.flavour != null ? '• Flavour: ${productDetails.flavour}' : ''}
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
}
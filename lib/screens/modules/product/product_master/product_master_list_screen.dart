import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/productDetailsBloc/productDetails_bloc.dart';
import '../../../../bloc/productMasterBloc/productMaster_bloc.dart';
import '../../../../bloc/productMasterBloc/productMaster_event.dart';
import '../../../../bloc/productMasterBloc/productMaster_state.dart';
import '../../../../model/product_model.dart';
import '../../../../services/product/product_details_http.dart';
import '../../../../utils/auth_guard.dart';
import '../product_details/product_details_create_screen.dart';
import '../product_details/product_details_screen.dart';
import 'product_master_create_screen.dart';
import 'product_master_edit_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductDetailsService _productDetailsService = ProductDetailsService();
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
      create: (context) => ProductBloc()..add(LoadProducts()),
      child: Scaffold(
        body: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              _showSnackBar(context, state.message, Colors.red);
            } else if (state is ProductUpdated) {
              _showSnackBar(context, 'Product updated successfully', Colors.green);
              context.read<ProductBloc>().add(LoadProducts());
            } else if (state is ProductCreated) {
              _showSnackBar(context, 'Product created successfully', Colors.green);
              context.read<ProductBloc>().add(LoadProducts());
            } else if (state is ProductDeleted) {
              _showSnackBar(context, 'Product deleted successfully', Colors.green);
              context.read<ProductBloc>().add(LoadProducts());
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                if (state is ProductLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is ProductsLoaded)
                  _buildProductList(context, state.products, _searchQuery)
                else if (state is ProductError)
                  SliverFillRemaining(child: _buildErrorWidget(context, state.message))
                else
                  const SliverFillRemaining(
                    child: Center(child: Text('Start managing your products')),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton.extended(
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Product'),
              onPressed: () => _navigateToCreateProduct(context),
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text('Product Master'),
      floating: true,
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(68.0), // Increased height
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            height: 48, // Fixed height for TextField
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                constraints: const BoxConstraints(
                  maxHeight: 48,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(
      BuildContext context, List<Product> products, String query) {
    final filteredProducts = products.where((product) {
      return product.productName.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.type.toLowerCase().contains(query);
    }).toList();

    if (filteredProducts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
              query.isEmpty ? 'No products found' : 'No products match "$query"'),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _ProductListItem(
            key: ValueKey(filteredProducts[index].productId),
            product: filteredProducts[index],
            onTap: () =>
                _navigateToProductDetails(context, filteredProducts[index]),
          );
        },
        childCount: filteredProducts.length,
      ),
    );
  }

  Future<void> _navigateToProductDetails(BuildContext context, Product product) async {
    if (product.productId == null) {
      _showSnackBar(context, 'Product ID not found', Colors.red);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final productDetails = await _productDetailsService.getProductDetailsByProductId(product.productId!);
      
      if (context.mounted) {
        Navigator.pop(context); 
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: product.productId!,
              initialProductDetails: productDetails,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        
        if (e.toString().contains('404') || 
            e.toString().toLowerCase().contains('not found')) {
          _navigateToCreateProductDetails(context, product);
        } else {
          _showSnackBar(context, 'Failed to load product details: ${e.toString()}', Colors.red);
        }
      }
      debugPrint('Error navigating to product details: $e');
    }
  }

  void _navigateToCreateProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Details Not Found'),
        content: Text('No details found for "${product.productName}". Would you like to create them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ProductDetailsBloc(),
                    child: CreateProductDetailsScreen(product: product),
                  ),
                ),
              );
            },
            child: const Text('Create Details'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToCreateProduct(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<ProductBloc>(context),
          child: const CreateProductScreen(),
        ),
      ),
    );

    if (result == true && context.mounted) {
      context.read<ProductBloc>().add(LoadProducts());
    }
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Error: $message', textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<ProductBloc>().add(LoadProducts());
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
}

class _ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductListItem({
    required this.product,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color getStatusColor(String status) {
      switch (status) {
        case 'Active':
          return Colors.green;
        case 'Inactive':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.productName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(product.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: getStatusColor(product.status),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              _buildInfoRow(
                  context, Icons.inventory_2_rounded, 'Type', product.type),
              _buildInfoRow(context, Icons.folder_open_rounded, 'Category',
                  product.category),
              if (product.subCategory != null &&
                  product.subCategory!.isNotEmpty)
                _buildInfoRow(context, Icons.subtitles_rounded, 'Sub Category',
                    product.subCategory!),
              _buildInfoRow(context, Icons.currency_exchange_rounded, 'Taxable',
                  product.isTaxable),
              _buildInfoRow(context, Icons.warehouse_rounded, 'Keeping Stock',
                  product.isKeepingStock),
               _buildInfoRow(context, Icons.calendar_month_outlined, 'Created on',
                  product.createdAt !=null ? _formatDateTime(product.createdAt!) : 'N/A'),
               _buildInfoRow(context, Icons.calendar_month, 'Updated on', 
                  product.updatedAt !=null ? _formatDateTime(product.updatedAt!) : 'N/A'),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionButton(
                    context,
                    Icons.edit_rounded,
                    'Edit',
                    colorScheme.secondary,
                    () => _navigateToEditProduct(context, product),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    context,
                    Icons.delete_rounded,
                    'Delete',
                    colorScheme.error,
                    () => _showDeleteConfirmation(context, product),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      Color color, VoidCallback onPressed) {
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

  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to permanently delete "${product.productName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                    DeleteProduct(product.productId!),
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

  Future<void> _navigateToEditProduct(
      BuildContext context, Product product) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<ProductBloc>(context),
          child: EditProductScreen(product: product),
        ),
      ),
    );

    if (result == true && context.mounted) {
      context.read<ProductBloc>().add(LoadProducts());
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }
}
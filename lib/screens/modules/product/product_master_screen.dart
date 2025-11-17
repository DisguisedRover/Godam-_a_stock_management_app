// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../bloc/productMasterBloc/productMaster_bloc.dart';
// import '../../../bloc/productMasterBloc/productMaster_event.dart';
// import '../../../bloc/productMasterBloc/productMaster_state.dart';
// import '../../../model/product_model.dart';

// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({Key? key}) : super(key: key);

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//   }

//   void _onSearchChanged() {
//     setState(() {
//       _searchQuery = _searchController.text.toLowerCase();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProductBloc()..add(LoadProducts()),
//       child: Scaffold(
//         body: BlocConsumer<ProductBloc, ProductState>(
//           listener: (context, state) {
//             if (state is ProductError) {
//               _showSnackBar(context, state.message, Colors.red);
//             } else if (state is ProductUpdated) {
//               _showSnackBar(context, 'Product updated successfully', Colors.green);
//               context.read<ProductBloc>().add(LoadProducts());
//             } else if (state is ProductCreated) {
//               _showSnackBar(context, 'Product created successfully', Colors.green);
//               context.read<ProductBloc>().add(LoadProducts());
//             } else if (state is ProductDeleted) {
//               _showSnackBar(context, 'Product deleted successfully', Colors.green);
//               context.read<ProductBloc>().add(LoadProducts());
//             }
//           },
//           builder: (context, state) {
//             return CustomScrollView(
//               slivers: [
//                 _buildAppBar(context),
//                 if (state is ProductLoading)
//                   const SliverFillRemaining(
//                     child: Center(child: CircularProgressIndicator()),
//                   )
//                 else if (state is ProductsLoaded)
//                   _buildProductList(context, state.products, _searchQuery)
//                 else if (state is ProductError)
//                   SliverFillRemaining(child: _buildErrorWidget(context, state.message))
//                 else
//                   const SliverFillRemaining(
//                     child: Center(child: Text('Start managing your products')),
//                   ),
//               ],
//             );
//           },
//         ),
//         floatingActionButton: Builder(
//           builder: (context) {
//             return FloatingActionButton.extended(
//               icon: const Icon(Icons.add_rounded),
//               label: const Text('New Product'),
//               onPressed: () => _showCreateProductSheet(context),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   SliverAppBar _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       title: const Text('Product Master'),
//       floating: true,
//       pinned: true,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(60.0),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search products...',
//               prefixIcon: const Icon(Icons.search_rounded),
//               suffixIcon: _searchQuery.isNotEmpty
//                   ? IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         _onSearchChanged();
//                       },
//                     )
//                   : null,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               contentPadding: const EdgeInsets.all(0),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductList(
//       BuildContext context, List<Product> products, String query) {
//     final filteredProducts = products.where((product) {
//       return product.productName.toLowerCase().contains(query) ||
//           product.category.toLowerCase().contains(query) ||
//           product.type.toLowerCase().contains(query);
//     }).toList();

//     if (filteredProducts.isEmpty) {
//       return SliverFillRemaining(
//         child: Center(
//           child: Text(
//               query.isEmpty ? 'No products found' : 'No products match "$query"'),
//         ),
//       );
//     }

//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (context, index) {
//           return _ProductListItem(
//             key: ValueKey(filteredProducts[index].productId), 
//             product: filteredProducts[index],
//           );
//         },
//         childCount: filteredProducts.length,
//       ),
//     );
//   }

//   Widget _buildErrorWidget(BuildContext context, String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
//           const SizedBox(height: 16),
//           Text('Error: $message', textAlign: TextAlign.center),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             icon: const Icon(Icons.refresh_rounded),
//             onPressed: () {
//               context.read<ProductBloc>().add(LoadProducts());
//             },
//             label: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSnackBar(BuildContext context, String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
  
//   // New: Use Modal Bottom Sheet for Create
//   void _showCreateProductSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (dialogContext) => BlocProvider.value(
//         value: BlocProvider.of<ProductBloc>(context),
//         child: Padding(
//           padding: EdgeInsets.only(
//             top: 20,
//             left: 20,
//             right: 20,
//             bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
//           ),
//           child: const _CreateProductSheet(), 
//         ),
//       ),
//     );
//   }
// }

// class _ProductListItem extends StatelessWidget {
//   final Product product;

//   const _ProductListItem({required this.product, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
    
//     Color getStatusColor(String status) {
//       switch (status) {
//         case 'Active':
//           return Colors.green;
//         case 'Inactive':
//           return Colors.red;
//         default:
//           return Colors.grey;
//       }
//     }

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     product.productName,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: colorScheme.primary,
//                         ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: getStatusColor(product.status).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     product.status,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: getStatusColor(product.status),
//                           fontWeight: FontWeight.w600,
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 16),
//             _buildInfoRow(context, Icons.inventory_2_rounded, 'Type', product.type),
//             _buildInfoRow(context, Icons.folder_open_rounded, 'Category', product.category),
//             if (product.subCategory != null && product.subCategory!.isNotEmpty)
//               _buildInfoRow(context, Icons.subtitles_rounded, 'Sub Category', product.subCategory!),
//             _buildInfoRow(context, Icons.currency_exchange_rounded, 'Taxable', product.isTaxable),
//             _buildInfoRow(context, Icons.warehouse_rounded, 'Keeping Stock', product.isKeepingStock),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 _buildActionButton(
//                   context,
//                   Icons.edit_rounded,
//                   'Edit',
//                   colorScheme.secondary,
//                   () => _showEditProductSheet(context, product), 
//                 ),
//                 const SizedBox(width: 8),
//                 _buildActionButton(
//                   context,
//                   Icons.delete_rounded,
//                   'Delete',
//                   colorScheme.error,
//                   () => _showDeleteConfirmation(context, product),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
//           const SizedBox(width: 8),
//           Text(
//             '$label: ',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
//           ),
//           Text(
//             value,
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onPressed) {
//     return OutlinedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon, size: 18),
//       label: Text(label),
//       style: OutlinedButton.styleFrom(
//         foregroundColor: color,
//         side: BorderSide(color: color.withOpacity(0.5)),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context, Product product) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: const Text('Confirm Deletion'),
//         content: Text('Are you sure you want to permanently delete **${product.productName}**?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               context.read<ProductBloc>().add(
//                     DeleteProduct(product.productId!),
//                   );
//               Navigator.pop(dialogContext);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void _showEditProductSheet(BuildContext context, Product product) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (dialogContext) => BlocProvider.value(
//       value: BlocProvider.of<ProductBloc>(context),
//       child: Padding(
//         padding: EdgeInsets.only(
//           top: 20,
//           left: 20,
//           right: 20,
//           bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
//         ),
//         child: _EditProductSheet(product: product),
//       ),
//     ),
//   );
// }

// class _CreateProductSheet extends StatefulWidget {
//   const _CreateProductSheet();

//   @override
//   State<_CreateProductSheet> createState() => _CreateProductSheetState();
// }

// class _CreateProductSheetState extends State<_CreateProductSheet> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _typeController = TextEditingController();
//   final _categoryController = TextEditingController();
//   final _subCategoryController = TextEditingController();

//   String _status = 'Active';
//   String _isTaxable = 'Yes';
//   String _isKeepingStock = 'Yes';
//   final DateTime _savedIn = DateTime.now();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _typeController.dispose();
//     _categoryController.dispose();
//     _subCategoryController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Create New Product',
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Flexible(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
//                     validator: (value) => value?.isEmpty ?? true ? 'Product name is required' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _typeController,
//                     decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
//                     validator: (value) => value?.isEmpty ?? true ? 'Type is required' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _categoryController,
//                     decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
//                     validator: (value) => value?.isEmpty ?? true ? 'Category is required' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _subCategoryController,
//                     decoration: const InputDecoration(labelText: 'Sub Category', border: OutlineInputBorder()),
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: _status,
//                     decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
//                     items: ['Active', 'Inactive']
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() => _status = value!);
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: _isTaxable,
//                     decoration: const InputDecoration(labelText: 'Is Taxable', border: OutlineInputBorder()),
//                     items: ['Yes', 'No']
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() => _isTaxable = value!);
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: _isKeepingStock,
//                     decoration: const InputDecoration(labelText: 'Keeping Stock', border: OutlineInputBorder()),
//                     items: ['Yes', 'No']
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() => _isKeepingStock = value!);
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // Action Buttons
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20.0),
//           child: ButtonBar(
//             buttonPadding: EdgeInsets.zero,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     final product = Product(
//                       productName: _nameController.text,
//                       type: _typeController.text,
//                       category: _categoryController.text,
//                       subCategory: _subCategoryController.text,
//                       isTaxable: _isTaxable,
//                       isKeepingStock: _isKeepingStock,
//                       savedIn: _savedIn,
//                       status: _status,
//                     );

//                     context.read<ProductBloc>().add(CreateProduct(product));
//                     Navigator.pop(context);
//                   }
//                 },
//                 icon: const Icon(Icons.check_rounded),
//                 label: const Text('Create'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _EditProductSheet extends StatefulWidget {
//   final Product product;

//   const _EditProductSheet({required this.product});

//   @override
//   State<_EditProductSheet> createState() => _EditProductSheetState();
// }

// class _EditProductSheetState extends State<_EditProductSheet> {
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameController;
//   late final TextEditingController _typeController;
//   late final TextEditingController _categoryController;
//   late final TextEditingController _subCategoryController;

//   late String _status;
//   late String _isTaxable;
//   late String _isKeepingStock;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.product.productName);
//     _typeController = TextEditingController(text: widget.product.type);
//     _categoryController = TextEditingController(text: widget.product.category);
//     _subCategoryController = TextEditingController(text: widget.product.subCategory);

//     _status = widget.product.status;
//     _isTaxable = widget.product.isTaxable;
//     _isKeepingStock = widget.product.isKeepingStock;
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _typeController.dispose();
//     _categoryController.dispose();
//     _subCategoryController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Edit ${widget.product.productName}',
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Flexible(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
//                     validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _typeController,
//                     decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
//                     validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _categoryController,
//                     decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
//                     validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   const SizedBox(height: 12),
//                   TextFormField(
//                     controller: _subCategoryController,
//                     decoration: const InputDecoration(labelText: 'Sub Category', border: OutlineInputBorder()),
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: _status,
//                     decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
//                     items: ['Active', 'Inactive']
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() => _status = value!);
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: _isTaxable,
//                     decoration: const InputDecoration(labelText: 'Is Taxable', border: OutlineInputBorder()),
//                     items: ['Yes', 'No']
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() => _isTaxable = value!);
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: _isKeepingStock,
//                     decoration: const InputDecoration(labelText: 'Keeping Stock', border: OutlineInputBorder()),
//                     items: ['Yes', 'No']
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() => _isKeepingStock = value!);
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // Action Buttons
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     final updatedProduct = Product(
//                       productId: widget.product.productId,
//                       productName: _nameController.text,
//                       type: _typeController.text,
//                       category: _categoryController.text,
//                       subCategory: _subCategoryController.text,
//                       isTaxable: _isTaxable,
//                       isKeepingStock: _isKeepingStock,
//                       savedIn: widget.product.savedIn,
//                       status: _status,
//                     );

//                     context.read<ProductBloc>().add(
//                           UpdateProduct(
//                             widget.product.productId!,
//                             updatedProduct,
//                           ),
//                         );
//                     Navigator.pop(context);
//                   }
//                 },
//                 icon: const Icon(Icons.save_rounded),
//                 label: const Text('Update'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/productMasterBloc/productMaster_bloc.dart';
import '../../../bloc/productMasterBloc/productMaster_event.dart';
import '../../../bloc/productMasterBloc/productMaster_state.dart';
import '../../../model/product_model.dart';
import '../../../services/product/product_details_http.dart';
import 'product_details_screen.dart';

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
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
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
              onPressed: () => _showCreateProductSheet(context),
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
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
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
            onTap: () => _navigateToProductDetails(context, filteredProducts[index]),
          );
        },
        childCount: filteredProducts.length,
      ),
    );
  }

  Future<void> _navigateToProductDetails(BuildContext context, Product product) async {
    // Check if product has an ID
    if (product.productId == null) {
      _showSnackBar(context, 'Product ID not found', Colors.red);
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Fetch product details from API using product_id
      final productDetails = await _productDetailsService.getProductDetailsById(product.productId!);
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
        
        // Navigate to details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productDetails: productDetails),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
        _showSnackBar(context, 'Failed to load product details: $e', Colors.red);
      }
      debugPrint('Error navigating to product details: $e');
    }
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
  
  void _showCreateProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<ProductBloc>(context),
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: const _CreateProductSheet(), 
        ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              _buildInfoRow(context, Icons.inventory_2_rounded, 'Type', product.type),
              _buildInfoRow(context, Icons.folder_open_rounded, 'Category', product.category),
              if (product.subCategory != null && product.subCategory!.isNotEmpty)
                _buildInfoRow(context, Icons.subtitles_rounded, 'Sub Category', product.subCategory!),
              _buildInfoRow(context, Icons.currency_exchange_rounded, 'Taxable', product.isTaxable),
              _buildInfoRow(context, Icons.warehouse_rounded, 'Keeping Stock', product.isKeepingStock),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionButton(
                    context,
                    Icons.edit_rounded,
                    'Edit',
                    colorScheme.secondary,
                    () => _showEditProductSheet(context, product), 
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
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
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

  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to permanently delete "${product.productName}"?'),
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

  void _showEditProductSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<ProductBloc>(context),
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: _EditProductSheet(product: product),
        ),
      ),
    );
  }
}

class _CreateProductSheet extends StatefulWidget {
  const _CreateProductSheet();

  @override
  State<_CreateProductSheet> createState() => _CreateProductSheetState();
}

class _CreateProductSheetState extends State<_CreateProductSheet> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create New Product',
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
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                    validator: (value) => value?.isEmpty ?? true ? 'Product name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _typeController,
                    decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                    validator: (value) => value?.isEmpty ?? true ? 'Type is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                    validator: (value) => value?.isEmpty ?? true ? 'Category is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _subCategoryController,
                    decoration: const InputDecoration(labelText: 'Sub Category', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: ['Active', 'Inactive']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _status = value!);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _isTaxable,
                    decoration: const InputDecoration(labelText: 'Is Taxable', border: OutlineInputBorder()),
                    items: ['Yes', 'No']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _isTaxable = value!);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _isKeepingStock,
                    decoration: const InputDecoration(labelText: 'Keeping Stock', border: OutlineInputBorder()),
                    items: ['Yes', 'No']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _isKeepingStock = value!);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
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
                    final product = Product(
                      productName: _nameController.text,
                      type: _typeController.text,
                      category: _categoryController.text,
                      subCategory: _subCategoryController.text,
                      isTaxable: _isTaxable,
                      isKeepingStock: _isKeepingStock,
                      savedIn: _savedIn,
                      status: _status,
                    );

                    context.read<ProductBloc>().add(CreateProduct(product));
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

class _EditProductSheet extends StatefulWidget {
  final Product product;

  const _EditProductSheet({required this.product});

  @override
  State<_EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<_EditProductSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _categoryController;
  late final TextEditingController _subCategoryController;

  late String _status;
  late String _isTaxable;
  late String _isKeepingStock;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.productName);
    _typeController = TextEditingController(text: widget.product.type);
    _categoryController = TextEditingController(text: widget.product.category);
    _subCategoryController = TextEditingController(text: widget.product.subCategory);

    _status = widget.product.status;
    _isTaxable = widget.product.isTaxable;
    _isKeepingStock = widget.product.isKeepingStock;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit ${widget.product.productName}',
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
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _typeController,
                    decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _subCategoryController,
                    decoration: const InputDecoration(labelText: 'Sub Category', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: ['Active', 'Inactive']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _status = value!);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _isTaxable,
                    decoration: const InputDecoration(labelText: 'Is Taxable', border: OutlineInputBorder()),
                    items: ['Yes', 'No']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _isTaxable = value!);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _isKeepingStock,
                    decoration: const InputDecoration(labelText: 'Keeping Stock', border: OutlineInputBorder()),
                    items: ['Yes', 'No']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _isKeepingStock = value!);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
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
                    final updatedProduct = Product(
                      productId: widget.product.productId,
                      productName: _nameController.text,
                      type: _typeController.text,
                      category: _categoryController.text,
                      subCategory: _subCategoryController.text,
                      isTaxable: _isTaxable,
                      isKeepingStock: _isKeepingStock,
                      savedIn: widget.product.savedIn,
                      status: _status,
                    );

                    context.read<ProductBloc>().add(
                          UpdateProduct(
                            widget.product.productId!,
                            updatedProduct,
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
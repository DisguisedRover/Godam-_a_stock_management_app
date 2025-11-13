import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/master_data_provider.dart';

class MasterTable extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<String> keys;
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> formFields;
  final Future<void> Function(Map<String, dynamic>) onSave;
  final Future<void> Function() onRefresh;

  const MasterTable({
    super.key,
    required this.title,
    required this.columns,
    required this.keys,
    required this.data,
    required this.formFields,
    required this.onSave,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildSearchAndFilter(),
            const SizedBox(height: 8),
            Expanded(child: _buildDataTable()),
            const SizedBox(height: 8),
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => onRefresh(),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: 'Active',
          items: ['Active', 'Inactive']
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns
              .map((column) => DataColumn(label: Text(column)))
              .toList(),
          rows: data.map((item) {
            return DataRow(
              cells: keys.map((key) {
                // final key = column.toLowerCase().replaceAll(' ', '');
                if (key == 'status') {
                  return DataCell(
                    Chip(
                      label: Text(
                        item[key] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: item[key] == 'Active'
                          ? Colors.green
                          : Colors.red,
                    ),
                  );
                }
                return DataCell(Text(item[key]?.toString() ?? ''));
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Displaying 1 to ${data.length} of ${data.length} items',
          style: const TextStyle(fontSize: 12),
        ),
        const Row(
          children: [
            IconButton(icon: Icon(Icons.first_page), onPressed: null),
            IconButton(icon: Icon(Icons.chevron_left), onPressed: null),
            Text('1'),
            IconButton(icon: Icon(Icons.chevron_right), onPressed: null),
            IconButton(icon: Icon(Icons.last_page), onPressed: null),
          ],
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controllers = <String, TextEditingController>{};

    for (var field in formFields) {
      controllers[field['key']] = TextEditingController();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New $title'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: formFields.map((field) {
                  if (field['type'] == 'dropdown') {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: field['label'],
                        border: const OutlineInputBorder(),
                      ),
                      items: (field['options'] as List<String>)
                          .map(
                            (option) => DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controllers[field['key']]!.text = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select ${field['label']}';
                        }
                        return null;
                      },
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      controller: controllers[field['key']],
                      decoration: InputDecoration(
                        labelText: field['label'],
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ${field['label']}';
                        }
                        return null;
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final data = <String, dynamic>{};
                  for (var field in formFields) {
                    data[field['key']] = controllers[field['key']]!.text;
                  }
                  try {
                    await onSave(data);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((_) {
      for (var controller in controllers.values) {
        controller.dispose();
      }
    });
  }
}

class MasterDataScreen extends StatefulWidget {
  const MasterDataScreen({super.key});

  @override
  State<MasterDataScreen> createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends State<MasterDataScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MasterDataProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MasterDataProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Master Data Management')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text('Error: ${provider.error}'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // First row of tables
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Base Unit Master
                        Expanded(
                          child: MasterTable(
                            title: 'Base Unit Master',
                            columns: const [
                              'Unit Name',
                              'Unit Value',
                              'Status',
                              'Saved By',
                              'Saved In',
                            ],
                            keys: [
                              'unitName',
                              'unitValue',
                              'status',
                              'savedBy',
                              'savedIn',
                            ],
                            data: provider.baseUnits,
                            formFields: [
                              {'label': 'Unit Name', 'key': 'unitName'},
                              {'label': 'Unit Value', 'key': 'unitValue'},
                              {
                                'label': 'Status',
                                'key': 'status',
                                'type': 'dropdown',
                                'options': ['Active', 'Inactive'],
                              },

                              {'label': 'Saved By', 'key': 'savedBy'},

                              {'label': 'Saved In', 'key': 'savedIn'},
                            ],
                            onSave: (data) => provider.addBaseUnit({
                              'name': data['unitName'],
                              'value': data['unitValue'],
                              'status': 'Active',
                            }),
                            onRefresh: provider.fetchBaseUnits,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Category Master
                        Expanded(
                          child: MasterTable(
                            title: 'Category Master',
                            columns: const [
                              'Category Name',
                              'Status',
                              'Saved By',
                              'Saved In',
                            ],
                            keys: [
                              'CategoryName',
                              'status',
                              'savedBy',
                              'savedIn',
                            ],
                            data: provider.categories,
                            formFields: [
                              {'label': 'Category Name', 'key': 'categoryName'},
                              {
                                'label': 'Status',
                                'key': 'status',
                                'type': 'dropdown',
                                'options': ['Active', 'Inactive'],
                              },

                              {'label': 'Saved By', 'key': 'savedBy'},

                              {'label': 'Saved In', 'key': 'savedIn'},
                            ],
                            onSave: (data) => provider.addCategory({
                              'name': data['categoryName'],
                              'status': 'Active',
                            }),
                            onRefresh: provider.fetchCategories,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Second row of tables
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sub Category Master
                        Expanded(
                          child: MasterTable(
                            title: 'Sub Category Master',
                            columns: const [
                              'Sub Category Name',
                              'Category Name',
                              'Status',
                              'Saved By',
                              'Saved In',
                            ],
                            keys: [
                              'subCategoryName',
                              'categoryName',
                              'status',
                              'savedBy',
                              'savedIn',
                            ],
                            data: provider.subCategories,
                            formFields: [
                              {
                                'label': 'Sub Category Name',
                                'key': 'subCategoryName',
                              },
                              {
                                'label': 'Category Name',
                                'key': 'categoryName',
                                'type': 'dropdown',
                                'options': provider.categories
                                    .map((c) => c['name'].toString())
                                    .toList(),
                              },
                              {
                                'label': 'Status',
                                'key': 'status',
                                'type': 'dropdown',
                                'options': ['Active', 'Inactive'],
                              },

                              {'label': 'Saved By', 'key': 'savedBy'},

                              {'label': 'Saved In', 'key': 'savedIn'},
                            ],
                            onSave: (data) => provider.addSubCategory({
                              'name': data['subCategoryName'],
                              'category': data['categoryName'],
                              'status': 'Active',
                            }),
                            onRefresh: provider.fetchSubCategories,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Flavor Master
                        Expanded(
                          child: MasterTable(
                            title: 'Flavor Master',
                            columns: const [
                              'Flavor Name',
                              'Status',
                              'Saved By',
                              'Saved In',
                            ],
                            keys: [
                              'flavorName',
                              'status',
                              'savedBy',
                              'savedIn',
                            ],
                            data: provider.flavors,
                            formFields: [
                              {'label': 'Flavor Name', 'key': 'flavorName'},
                              {
                                'label': 'Status',
                                'key': 'status',
                                'type': 'dropdown',
                                'options': ['Active', 'Inactive'],
                              },

                              {'label': 'Saved By', 'key': 'savedBy'},

                              {'label': 'Saved In', 'key': 'savedIn'},
                            ],
                            onSave: (data) => provider.addFlavor({
                              'name': data['flavorName'],
                              'status': 'Active',
                            }),
                            onRefresh: provider.fetchFlavors,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Copyright © 2025'),
          Text('Economic Year: 2082/2083'),
          Text('License To: Nirajan Gaha'),
        ],
      ),
    );
  }
}

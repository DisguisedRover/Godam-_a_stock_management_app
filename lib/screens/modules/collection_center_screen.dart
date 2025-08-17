import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/collection_center_provider.dart';
import '../../theme/app_theme.dart';

enum CenterStatus { active, inactive }

enum BranchType { collectionCenter, branchOffice, salesCounter }

class CollectionCenterScreen extends StatefulWidget {
  const CollectionCenterScreen({super.key});

  @override
  State<CollectionCenterScreen> createState() => _CollectionCenterScreenState();
}

class _CollectionCenterScreenState extends State<CollectionCenterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactNoController = TextEditingController();
  final _contactPersonController = TextEditingController();

  CenterStatus? _selectedStatus = CenterStatus.active;
  BranchType? _selectedBranchType = BranchType.collectionCenter;
  bool _affectsStock = false;

  CenterStatus? _selectedTableFilterStatus = CenterStatus.active;
  BranchType? _selectedTableFilterBranchType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthenticationAndFetchData();
    });
  }

  Future<void> _checkAuthenticationAndFetchData() async {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // if (!authProvider.isAuthenticated) {
    //   Navigator.pushReplacementNamed(context, '/');
    //   return;
    // }

    final centerProvider = Provider.of<CollectionCenterProvider>(
      context,
      listen: false,
    );
    await centerProvider.fetchCollectionCenters();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _contactNoController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _codeController.clear();
    _nameController.clear();
    _addressController.clear();
    _contactNoController.clear();
    _contactPersonController.clear();
    setState(() {
      _selectedStatus = CenterStatus.active;
      _selectedBranchType = BranchType.collectionCenter;
      _affectsStock = false;
    });
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final centerProvider = Provider.of<CollectionCenterProvider>(
          context,
          listen: false,
        );

        final centerData = {
          'code': _codeController.text,
          'name': _nameController.text,
          'address': _addressController.text,
          'contactNo': _contactNoController.text,
          'contactPerson': _contactPersonController.text,
          'branchType': _selectedBranchType.toString().split('.').last,
          'affectsStock': _affectsStock ? '1' : '0',
          'status': _selectedStatus.toString().split('.').last,
        };

        await centerProvider.saveCollectionCenter(centerData);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Collection center saved successfully!'),
            backgroundColor: AppTheme.primaryRetroModern,
          ),
        );
        _clearForm();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving collection center: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final centerProvider = Provider.of<CollectionCenterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Center/Sales Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: centerProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRetroModern,
              ),
            )
          : _buildMainLayout(theme, isDarkMode, centerProvider),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildMainLayout(
    ThemeData theme,
    bool isDarkMode,
    CollectionCenterProvider centerProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Panel - Form
          Flexible(flex: 1, child: _buildFormPanel(theme)),
          const SizedBox(width: 16),
          // Right Panel - Table
          Flexible(
            flex: 2,
            child: _buildTablePanel(theme, isDarkMode, centerProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildFormPanel(ThemeData theme) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Collection Center/Sales Counter Entry',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fields with * are mandatory',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  context,
                  controller: _codeController,
                  labelText: 'Code*',
                  isRequired: true,
                ),
                _buildTextField(
                  context,
                  controller: _nameController,
                  labelText: 'Name*',
                  isRequired: true,
                ),
                _buildTextField(
                  context,
                  controller: _addressController,
                  labelText: 'Address*',
                  isRequired: true,
                  maxLines: 2,
                ),
                _buildTextField(
                  context,
                  controller: _contactNoController,
                  labelText: 'Contact No*',
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  context,
                  controller: _contactPersonController,
                  labelText: 'Contact Person*',
                  isRequired: true,
                ),
                _buildDropdownField<BranchType>(
                  context,
                  value: _selectedBranchType,
                  items: BranchType.values,
                  labelText: 'Branch Type*',
                  isRequired: true,
                  onChanged: (newValue) =>
                      setState(() => _selectedBranchType = newValue),
                  itemBuilder: (type) {
                    switch (type) {
                      case BranchType.collectionCenter:
                        return 'Collection Center';
                      case BranchType.branchOffice:
                        return 'Branch Office';
                      case BranchType.salesCounter:
                        return 'Sales Counter';
                    }
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Does it affect the main stock during collection entry?',
                  ),
                  value: _affectsStock,
                  onChanged: (value) => setState(() => _affectsStock = value),
                  activeColor: AppTheme.primaryRetroModern,
                ),
                _buildDropdownField<CenterStatus>(
                  context,
                  value: _selectedStatus,
                  items: CenterStatus.values,
                  labelText: 'Status*',
                  isRequired: true,
                  onChanged: (newValue) =>
                      setState(() => _selectedStatus = newValue),
                  itemBuilder: (status) => status.toString().split('.').last,
                ),
                const SizedBox(height: 30),
                _buildFormButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _saveForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: AppTheme.primaryRetroModern,
            ),
            child: const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: _clearForm,
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

  Widget _buildTablePanel(
    ThemeData theme,
    bool isDarkMode,
    CollectionCenterProvider centerProvider,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collection Center/Sales Counter List',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildTableControls(theme),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildDataTable(theme, isDarkMode, centerProvider),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPaginationControls(centerProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTableControls(ThemeData theme) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: _buildDropdownField<BranchType>(
            context,
            value: _selectedTableFilterBranchType,
            items: BranchType.values,
            labelText: 'Branch Type',
            isRequired: false,
            onChanged: (newValue) {
              setState(() => _selectedTableFilterBranchType = newValue);
              Provider.of<CollectionCenterProvider>(
                context,
                listen: false,
              ).filterCenters(branchType: newValue?.toString().split('.').last);
            },
            itemBuilder: (type) {
              switch (type) {
                case BranchType.collectionCenter:
                  return 'Collection Center';
                case BranchType.branchOffice:
                  return 'Branch Office';
                case BranchType.salesCounter:
                  return 'Sales Counter';
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 180,
          child: _buildDropdownField<CenterStatus>(
            context,
            value: _selectedTableFilterStatus,
            items: CenterStatus.values,
            labelText: 'Status',
            isRequired: false,
            onChanged: (newValue) {
              setState(() => _selectedTableFilterStatus = newValue);
              Provider.of<CollectionCenterProvider>(
                context,
                listen: false,
              ).filterCenters(status: newValue?.toString().split('.').last);
            },
            itemBuilder: (status) => status.toString().split('.').last,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            onPressed: () => Provider.of<CollectionCenterProvider>(
              context,
              listen: false,
            ).fetchCollectionCenters(),
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
            onPressed: () => _showSnackBar('Edit pressed...'),
            icon: const Icon(Icons.edit, size: 20),
            label: const Text('Edit', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryRetroModern),
              foregroundColor: AppTheme.primaryRetroModern,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(
            onPressed: () => _showSnackBar('Export to Excel pressed...'),
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

  Widget _buildDataTable(
    ThemeData theme,
    bool isDarkMode,
    CollectionCenterProvider centerProvider,
  ) {
    final centers = centerProvider.filteredCenters.isNotEmpty
        ? centerProvider.filteredCenters
        : centerProvider.centers;

    return DataTable(
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
        DataColumn(label: Text('Code', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Name', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Address', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Contact No', style: _boldColumnStyle(theme))),
        DataColumn(
          label: Text('Contact Person', style: _boldColumnStyle(theme)),
        ),
        DataColumn(label: Text('Branch Type', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Is Affected', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Saved By', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Saved In', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Status', style: _boldColumnStyle(theme))),
      ],
      rows: centers.map((center) => _buildDataRow(center, theme)).toList(),
    );
  }

  TextStyle _boldColumnStyle(ThemeData theme) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> center, ThemeData theme) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            center['code'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            center['name'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            center['address'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            center['contactNo'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            center['contactPerson'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            center['branchType'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            center['affectsStock'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            center['savedBy'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            center['savedIn'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Chip(
            label: Text(
              center['status'] ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            backgroundColor: center['status']?.toLowerCase() == 'active'
                ? Colors.green
                : Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls(CollectionCenterProvider centerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Displaying 1 to ${centerProvider.centers.length} of ${centerProvider.centers.length} items',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Row(
          children: [
            IconButton(
              onPressed: centerProvider.currentPage == 1
                  ? null
                  : () => centerProvider.goToFirstPage(),
              icon: Icon(
                Icons.first_page,
                color: centerProvider.currentPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed: centerProvider.currentPage == 1
                  ? null
                  : () => centerProvider.goToPreviousPage(),
              icon: Icon(
                Icons.chevron_left,
                color: centerProvider.currentPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Page ${centerProvider.currentPage} of ${centerProvider.totalPages}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed: centerProvider.currentPage == centerProvider.totalPages
                  ? null
                  : () => centerProvider.goToNextPage(),
              icon: Icon(
                Icons.chevron_right,
                color: centerProvider.currentPage == centerProvider.totalPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed: centerProvider.currentPage == centerProvider.totalPages
                  ? null
                  : () => centerProvider.goToLastPage(),
              icon: Icon(
                Icons.last_page,
                color: centerProvider.currentPage == centerProvider.totalPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Copyright © 2025'),
          // const Text('v6.3.1.0/6.3.1.0'),
          // Text('Logged In As: ${authProvider.user?.name ?? 'Unknown'}'),
          const Text('Economic Year: 2082/2083'),
          const Text('License To: CMP Trade Concern'),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
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

  Widget _buildDropdownField<T>(
    BuildContext context, {
    required T? value,
    required List<T> items,
    required String labelText,
    required bool isRequired,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemBuilder,
    double? width,
  }) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: width ?? double.infinity,
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
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryRetroModern,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/driver_provider.dart';
import '../../theme/app_theme.dart';

enum DriverStatus { active, inactive }

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _driverNameController = TextEditingController();
  final _driverContactController = TextEditingController();
  DriverStatus? _selectedStatus = DriverStatus.active;
  DriverStatus? _selectedTableFilterStatus = DriverStatus.active;

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

    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    await driverProvider.fetchDrivers();
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _driverContactController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _driverNameController.clear();
    _driverContactController.clear();
    setState(() => _selectedStatus = DriverStatus.active);
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final driverProvider = Provider.of<DriverProvider>(
          context,
          listen: false,
        );

        final driverData = {
          'driverName': _driverNameController.text,
          'contactNumber': _driverContactController.text,
          'status': _selectedStatus.toString().split('.').last,
        };

        await driverProvider.saveDriver(driverData);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Driver data saved successfully!'),
            backgroundColor: AppTheme.primaryRetroModern,
          ),
        );
        _clearForm();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving driver: ${e.toString()}'),
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
    final driverProvider = Provider.of<DriverProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Registration'),
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
      body: driverProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRetroModern,
              ),
            )
          : _buildMainLayout(theme, isDarkMode, driverProvider),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildMainLayout(
    ThemeData theme,
    bool isDarkMode,
    DriverProvider driverProvider,
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
            child: _buildTablePanel(theme, isDarkMode, driverProvider),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver Registration',
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
                controller: _driverNameController,
                labelText: 'Driver Name*',
                isRequired: true,
              ),
              _buildTextField(
                context,
                controller: _driverContactController,
                labelText: 'Driver Contact*',
                isRequired: true,
                keyboardType: TextInputType.phone,
              ),
              _buildDropdownField<DriverStatus>(
                context,
                value: _selectedStatus,
                items: DriverStatus.values,
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
    DriverProvider driverProvider,
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
              'Driver Details',
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
                  child: _buildDataTable(theme, isDarkMode, driverProvider),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPaginationControls(driverProvider),
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
          child: _buildDropdownField<DriverStatus>(
            context,
            value: _selectedTableFilterStatus,
            items: DriverStatus.values,
            labelText: 'Status',
            isRequired: false,
            onChanged: (newValue) {
              setState(() => _selectedTableFilterStatus = newValue);
              Provider.of<DriverProvider>(
                context,
                listen: false,
              ).filterDriversByStatus(newValue?.toString().split('.').last);
            },
            itemBuilder: (status) => status.toString().split('.').last,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            onPressed: () => Provider.of<DriverProvider>(
              context,
              listen: false,
            ).fetchDrivers(),
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
      ],
    );
  }

  Widget _buildDataTable(
    ThemeData theme,
    bool isDarkMode,
    DriverProvider driverProvider,
  ) {
    final drivers = driverProvider.filteredDrivers.isNotEmpty
        ? driverProvider.filteredDrivers
        : driverProvider.drivers;

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
        DataColumn(label: Text('#', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Driver Name', style: _boldColumnStyle(theme))),
        DataColumn(
          label: Text('Contact Number', style: _boldColumnStyle(theme)),
        ),
        DataColumn(label: Text('Is Available', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Saved By', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Saved in', style: _boldColumnStyle(theme))),
      ],
      rows: drivers.map((driver) => _buildDataRow(driver, theme)).toList(),
    );
  }

  TextStyle _boldColumnStyle(ThemeData theme) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> driver, ThemeData theme) {
    return DataRow(
      cells: [
        DataCell(
          Text('1', style: TextStyle(color: theme.colorScheme.onSurface)),
        ),
        DataCell(
          Text(
            driver['driverName'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            driver['contactNumber'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Chip(
            label: Text(
              driver['isAvailable'] == true ? 'Yes' : 'No',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            backgroundColor: driver['isAvailable'] == true
                ? Colors.green
                : Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
        DataCell(
          Text(
            driver['savedBy'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            driver['savedIn'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls(DriverProvider driverProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Displaying 1 to ${driverProvider.drivers.length} of ${driverProvider.drivers.length} items',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Row(
          children: [
            IconButton(
              onPressed: driverProvider.currentPage == 1
                  ? null
                  : () => driverProvider.goToFirstPage(),
              icon: Icon(
                Icons.first_page,
                color: driverProvider.currentPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed: driverProvider.currentPage == 1
                  ? null
                  : () => driverProvider.goToPreviousPage(),
              icon: Icon(
                Icons.chevron_left,
                color: driverProvider.currentPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Page ${driverProvider.currentPage} of ${driverProvider.totalPages}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed: driverProvider.currentPage == driverProvider.totalPages
                  ? null
                  : () => driverProvider.goToNextPage(),
              icon: Icon(
                Icons.chevron_right,
                color: driverProvider.currentPage == driverProvider.totalPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed: driverProvider.currentPage == driverProvider.totalPages
                  ? null
                  : () => driverProvider.goToLastPage(),
              icon: Icon(
                Icons.last_page,
                color: driverProvider.currentPage == driverProvider.totalPages
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

// Enums for dropdown values
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../theme/app_theme.dart';

enum ServicingPeriodType { days, months, years }

enum VehicleStatus { active, inactive }

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _vehicleNoController = TextEditingController();
  final _vehicleNameController = TextEditingController();
  final _chassisNoController = TextEditingController();
  final _engineNoController = TextEditingController();
  final _capacityController = TextEditingController();
  final _fuelTankCapacityController = TextEditingController();
  final _servicingPeriodController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _remarksController = TextEditingController();

  // Dropdown values
  ServicingPeriodType? _selectedServicingPeriodType = ServicingPeriodType.days;
  VehicleStatus? _selectedStatus = VehicleStatus.active;
  VehicleStatus? _selectedTableFilterStatus = VehicleStatus.active;

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

    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    await vehicleProvider.fetchVehicles();
  }

  @override
  void dispose() {
    _vehicleNoController.dispose();
    _vehicleNameController.dispose();
    _chassisNoController.dispose();
    _engineNoController.dispose();
    _capacityController.dispose();
    _fuelTankCapacityController.dispose();
    _servicingPeriodController.dispose();
    _mobileNumberController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _vehicleNoController.clear();
    _vehicleNameController.clear();
    _chassisNoController.clear();
    _engineNoController.clear();
    _capacityController.clear();
    _fuelTankCapacityController.clear();
    _servicingPeriodController.clear();
    _mobileNumberController.clear();
    _remarksController.clear();
    setState(() {
      _selectedServicingPeriodType = ServicingPeriodType.days;
      _selectedStatus = VehicleStatus.active;
    });
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final vehicleProvider = Provider.of<VehicleProvider>(
          context,
          listen: false,
        );

        final vehicleData = {
          'vehicleNo': _vehicleNoController.text,
          'vehicleName': _vehicleNameController.text,
          'chassisNo': _chassisNoController.text,
          'engineNo': _engineNoController.text,
          'capacity': _capacityController.text,
          'fuelTankCapacity': _fuelTankCapacityController.text,
          'servicingPeriod': _servicingPeriodController.text,
          'servicingPeriodType': _selectedServicingPeriodType
              .toString()
              .split('.')
              .last,
          'mobileNumber': _mobileNumberController.text,
          'remarks': _remarksController.text,
          'status': _selectedStatus.toString().split('.').last,
        };

        await vehicleProvider.saveVehicle(vehicleData);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Vehicle data saved successfully!'),
            backgroundColor: AppTheme.primaryRetroModern,
          ),
        );
        _clearForm();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving vehicle: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Registration'),
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
      body: vehicleProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRetroModern,
              ),
            )
          : _buildMainLayout(theme, isDarkMode, vehicleProvider),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildMainLayout(
    ThemeData theme,
    bool isDarkMode,
    VehicleProvider vehicleProvider,
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
            child: _buildTablePanel(theme, isDarkMode, vehicleProvider),
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
              children: [
                _buildFormHeader(theme),
                const SizedBox(height: 20),
                _buildFormFields(theme),
                const SizedBox(height: 30),
                _buildFormButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Registration',
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
      ],
    );
  }

  Widget _buildFormFields(ThemeData theme) {
    return Column(
      children: [
        _buildTextField(
          context,
          controller: _vehicleNoController,
          labelText: 'Vehicle No.',
          isRequired: true,
        ),
        _buildTextField(
          context,
          controller: _vehicleNameController,
          labelText: 'Vehicle Name',
          isRequired: true,
        ),
        _buildTextField(
          context,
          controller: _chassisNoController,
          labelText: 'Chassis No.',
          isRequired: true,
        ),
        _buildTextField(
          context,
          controller: _engineNoController,
          labelText: 'Engine No.',
          isRequired: true,
        ),
        _buildTextField(
          context,
          controller: _capacityController,
          labelText: 'Capacity',
          isRequired: true,
          keyboardType: TextInputType.number,
        ),
        _buildTextField(
          context,
          controller: _fuelTankCapacityController,
          labelText: 'Fuel Tank Capacity (in Liter)',
          keyboardType: TextInputType.number,
        ),
        _buildTextField(
          context,
          controller: _servicingPeriodController,
          labelText: 'Servicing Period',
          keyboardType: TextInputType.number,
        ),
        _buildDropdownField<ServicingPeriodType>(
          context,
          value: _selectedServicingPeriodType,
          items: ServicingPeriodType.values,
          labelText: 'Servicing Period Type',
          isRequired: true,
          onChanged: (newValue) =>
              setState(() => _selectedServicingPeriodType = newValue),
          itemBuilder: (type) => type.toString().split('.').last,
        ),
        _buildTextField(
          context,
          controller: _mobileNumberController,
          labelText: 'Mobile Number',
          keyboardType: TextInputType.phone,
        ),
        _buildTextField(
          context,
          controller: _remarksController,
          labelText: 'Remarks',
          maxLines: 3,
        ),
        _buildDropdownField<VehicleStatus>(
          context,
          value: _selectedStatus,
          items: VehicleStatus.values,
          labelText: 'Status',
          isRequired: true,
          onChanged: (newValue) => setState(() => _selectedStatus = newValue),
          itemBuilder: (status) => status.toString().split('.').last,
        ),
      ],
    );
  }

  Widget _buildFormButtons() {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: double.infinity),
      child: Row(
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
      ),
    );
  }

  Widget _buildTablePanel(
    ThemeData theme,
    bool isDarkMode,
    VehicleProvider vehicleProvider,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(theme),
            const SizedBox(height: 16),
            _buildTableControls(theme),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildDataTable(theme, isDarkMode, vehicleProvider),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPaginationControls(vehicleProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(ThemeData theme) {
    return Text(
      'Vehicle Details',
      style: theme.textTheme.headlineMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTableControls(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: _buildDropdownField<VehicleStatus>(
              context,
              value: _selectedTableFilterStatus,
              items: VehicleStatus.values,
              labelText: 'Status',
              isRequired: false,
              onChanged: (newValue) {
                setState(() => _selectedTableFilterStatus = newValue);
                Provider.of<VehicleProvider>(
                  context,
                  listen: false,
                ).filterVehiclesByStatus(newValue as String?);
              },
              itemBuilder: (status) => status.toString().split('.').last,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: ElevatedButton.icon(
              onPressed: () => Provider.of<VehicleProvider>(
                context,
                listen: false,
              ).fetchVehicles(),
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
      ),
    );
  }

  Widget _buildDataTable(
    ThemeData theme,
    bool isDarkMode,
    VehicleProvider vehicleProvider,
  ) {
    final vehicles = vehicleProvider.filteredVehicles.isNotEmpty
        ? vehicleProvider.filteredVehicles
        : vehicleProvider.vehicles;

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
        DataColumn(
          label: Text(
            'Vehicle No.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Vehicle Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Chassis No.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Engine No.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Capacity',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Mobile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Servicing',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
      rows: vehicles.map((data) => _buildDataRow(data, theme)).toList(),
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> data, ThemeData theme) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            data['vehicleNo'].toString(),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Chip(
            label: Text(
              data['isAvailable'] ? 'Active' : 'Inactive',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            backgroundColor: data['isAvailable']
                ? AppTheme.primaryRetroModern
                : Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
        DataCell(
          Text(
            data['vehicleName'].toString(),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            data['chassisNo'].toString(),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            data['engineNo'].toString(),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            data['capacity'].toString(),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            data['mobileNumber'].toString(),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            '${data['servicingPeriod']} ${data['servicingPeriodType']}',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls(VehicleProvider vehicleProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Displaying 1 to ${vehicleProvider.vehicles.length} of ${vehicleProvider.vehicles.length} items',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Row(
          children: [
            IconButton(
              onPressed: vehicleProvider.currentPage == 1
                  ? null
                  : () => vehicleProvider.goToFirstPage(),
              icon: Icon(
                Icons.first_page,
                color: vehicleProvider.currentPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed: vehicleProvider.currentPage == 1
                  ? null
                  : () => vehicleProvider.goToPreviousPage(),
              icon: Icon(
                Icons.chevron_left,
                color: vehicleProvider.currentPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Page ${vehicleProvider.currentPage} of ${vehicleProvider.totalPages}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed:
                  vehicleProvider.currentPage == vehicleProvider.totalPages
                  ? null
                  : () => vehicleProvider.goToNextPage(),
              icon: Icon(
                Icons.chevron_right,
                color: vehicleProvider.currentPage == vehicleProvider.totalPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed:
                  vehicleProvider.currentPage == vehicleProvider.totalPages
                  ? null
                  : () => vehicleProvider.goToLastPage(),
              icon: Icon(
                Icons.last_page,
                color: vehicleProvider.currentPage == vehicleProvider.totalPages
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryRetroModern,
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
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/delivery_provider.dart';
import '../../theme/app_theme.dart';

// Assuming you have these models or enums defined elsewhere
// enum CenterStatus { active, inactive }
// enum BranchType { collectionCenter, branchOffice, salesCounter }
// For Delivery, we might need enums for 'sendFrom' and 'receivedTo' but
// for this example, we'll keep them as Strings as in the original code.
enum DeliveryShift { morning, evening }

class DeliveryEntryScreen extends StatefulWidget {
  const DeliveryEntryScreen({super.key});

  @override
  State<DeliveryEntryScreen> createState() => _DeliveryEntryScreenState();
}

class _DeliveryEntryScreenState extends State<DeliveryEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNoController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _milkQtyController = TextEditingController();
  final _lactoController = TextEditingController();
  final _fatController = TextEditingController();
  final _snfController = TextEditingController();
  final _fatRateController = TextEditingController();
  final _fatUnitController = TextEditingController();
  final _fatAmountController = TextEditingController();

  String? _sendFrom; // In a real app, this would likely be an ID or an enum
  String? _receivedTo;
  DeliveryShift? _selectedShift;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Table filter controls
  String? _selectedTableFilterSendFrom;
  String? _selectedTableFilterReceivedTo;
  DeliveryShift? _selectedTableFilterShift;
  DateTime _selectedTableFilterDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthenticationAndFetchData();
    });
  }

  Future<void> _checkAuthenticationAndFetchData() async {
    // Authentication logic as in the collection center screen
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // if (!authProvider.isAuthenticated) {
    //   Navigator.pushReplacementNamed(context, '/');
    //   return;
    // }

    final deliveryProvider = Provider.of<DeliveryProvider>(
      context,
      listen: false,
    );
    await deliveryProvider.fetchDeliveries();
  }

  @override
  void dispose() {
    _vehicleNoController.dispose();
    _driverNameController.dispose();
    _milkQtyController.dispose();
    _lactoController.dispose();
    _fatController.dispose();
    _snfController.dispose();
    _fatRateController.dispose();
    _fatUnitController.dispose();
    _fatAmountController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _vehicleNoController.clear();
    _driverNameController.clear();
    _milkQtyController.clear();
    _lactoController.clear();
    _fatController.clear();
    _snfController.clear();
    _fatRateController.clear();
    _fatUnitController.clear();
    _fatAmountController.clear();
    setState(() {
      _sendFrom = null;
      _receivedTo = null;
      _selectedShift = null;
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    });
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final deliveryProvider = Provider.of<DeliveryProvider>(
          context,
          listen: false,
        );

        final deliveryData = {
          'sendFrom': _sendFrom,
          'receivedTo': _receivedTo,
          'shift': _selectedShift.toString().split('.').last,
          'dateTime':
              '${DateFormat('yyyy-MM-dd').format(_selectedDate)} ${_selectedTime.format(context)}',
          'milkQty': _milkQtyController.text,
          'lacto': _lactoController.text,
          'fat': _fatController.text,
          'snf': _snfController.text,
          'vehicleNo': _vehicleNoController.text,
          'fatRate': _fatRateController.text,
          'fatUnit': _fatUnitController.text,
          'fatAmount': _fatAmountController.text,
          'driverName': _driverNameController.text,
        };

        await deliveryProvider.saveDelivery(deliveryData);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delivery saved successfully!'),
            backgroundColor: AppTheme.primaryRetroModern,
          ),
        );
        _clearForm();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving delivery: ${e.toString()}'),
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
    final deliveryProvider = Provider.of<DeliveryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Entry'),
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
      body: deliveryProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRetroModern,
              ),
            )
          : _buildMainLayout(theme, isDarkMode, deliveryProvider),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildMainLayout(
    ThemeData theme,
    bool isDarkMode,
    DeliveryProvider deliveryProvider,
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
            child: _buildTablePanel(theme, isDarkMode, deliveryProvider),
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
                  'Delivery Entry Form',
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
                _buildDropdownField<String>(
                  context,
                  value: _sendFrom,
                  items: const [
                    'Collection Center 1',
                    'Collection Center 2',
                  ], // Example data
                  labelText: 'Send From*',
                  isRequired: true,
                  onChanged: (newValue) => setState(() => _sendFrom = newValue),
                  itemBuilder: (item) => item,
                ),
                _buildDropdownField<String>(
                  context,
                  value: _receivedTo,
                  items: const ['Plant A', 'Plant B'], // Example data
                  labelText: 'Received To*',
                  isRequired: true,
                  onChanged: (newValue) =>
                      setState(() => _receivedTo = newValue),
                  itemBuilder: (item) => item,
                ),
                _buildDropdownField<DeliveryShift>(
                  context,
                  value: _selectedShift,
                  items: DeliveryShift.values,
                  labelText: 'Shift*',
                  isRequired: true,
                  onChanged: (newValue) =>
                      setState(() => _selectedShift = newValue),
                  itemBuilder: (shift) => shift.toString().split('.').last,
                ),
                _buildDateTimeFields(),
                _buildTextField(
                  context,
                  controller: _vehicleNoController,
                  labelText: 'Vehicle No*',
                  isRequired: true,
                ),
                _buildTextField(
                  context,
                  controller: _driverNameController,
                  labelText: 'Driver Name*',
                  isRequired: true,
                ),
                _buildTextField(
                  context,
                  controller: _milkQtyController,
                  labelText: 'Milk Quantity (Litre)*',
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  context,
                  controller: _lactoController,
                  labelText: 'Lacto*',
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  context,
                  controller: _fatController,
                  labelText: 'Fat*',
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  context,
                  controller: _snfController,
                  labelText: 'SNF*',
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  context,
                  controller: _fatRateController,
                  labelText: 'Fat Rate*',
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  context,
                  controller: _fatUnitController,
                  labelText: 'Fat Unit*',
                  isRequired: true,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  context,
                  controller: _fatAmountController,
                  labelText: 'Fat Amount*',
                  isRequired: true,
                  keyboardType: TextInputType.number,
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

  Widget _buildDateTimeFields() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Time*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  _selectedTime.format(context),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
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
    DeliveryProvider deliveryProvider,
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
              'Delivery List',
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
                  child: _buildDataTable(theme, isDarkMode, deliveryProvider),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPaginationControls(deliveryProvider),
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
          child: _buildDropdownField<String>(
            context,
            value: _selectedTableFilterSendFrom,
            items: const [
              'Collection Center 1',
              'Collection Center 2',
            ], // Example data
            labelText: 'Send From',
            isRequired: false,
            onChanged: (newValue) {
              setState(() => _selectedTableFilterSendFrom = newValue);
              Provider.of<DeliveryProvider>(
                context,
                listen: false,
              ).filterDeliveries(sendFrom: newValue);
            },
            itemBuilder: (item) => item,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 180,
          child: _buildDropdownField<String>(
            context,
            value: _selectedTableFilterReceivedTo,
            items: const ['Plant A', 'Plant B'], // Example data
            labelText: 'Received To',
            isRequired: false,
            onChanged: (newValue) {
              setState(() => _selectedTableFilterReceivedTo = newValue);
              Provider.of<DeliveryProvider>(
                context,
                listen: false,
              ).filterDeliveries(receivedTo: newValue);
            },
            itemBuilder: (item) => item,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 180,
          child: _buildDropdownField<DeliveryShift>(
            context,
            value: _selectedTableFilterShift,
            items: DeliveryShift.values,
            labelText: 'Shift',
            isRequired: false,
            onChanged: (newValue) {
              setState(() => _selectedTableFilterShift = newValue);
              Provider.of<DeliveryProvider>(
                context,
                listen: false,
              ).filterDeliveries(shift: newValue?.toString().split('.').last);
            },
            itemBuilder: (shift) => shift.toString().split('.').last,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            onPressed: () =>
                Provider.of<DeliveryProvider>(
                  context,
                  listen: false,
                ).fetchDeliveries(
                  sendFrom: _selectedTableFilterSendFrom,
                  receivedTo: _selectedTableFilterReceivedTo,
                  shift: _selectedTableFilterShift?.toString().split('.').last,
                ),
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
    DeliveryProvider deliveryProvider,
  ) {
    final deliveries = deliveryProvider.filteredDeliveries.isNotEmpty
        ? deliveryProvider.filteredDeliveries
        : deliveryProvider.deliveries;

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
        DataColumn(label: Text('Send From', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Received To', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Shift', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Date & Time', style: _boldColumnStyle(theme))),
        DataColumn(
          label: Text('Milk Qty (Litre)', style: _boldColumnStyle(theme)),
        ),
        DataColumn(label: Text('Lacto', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Fat', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('SNF', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Vehicle No', style: _boldColumnStyle(theme))),
        DataColumn(label: Text('Driver Name', style: _boldColumnStyle(theme))),
      ],
      rows: deliveries
          .map((delivery) => _buildDataRow(delivery, theme))
          .toList(),
    );
  }

  TextStyle _boldColumnStyle(ThemeData theme) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  DataRow _buildDataRow(Map<String, dynamic> delivery, ThemeData theme) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            delivery['sendFrom'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['receivedTo'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['shift'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['dateTime'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['milkQty'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['lacto'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['fat'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['snf'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['vehicleNo'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            delivery['driverName'] ?? '',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls(DeliveryProvider deliveryProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Displaying 1 to ${deliveryProvider.deliveries.length} of ${deliveryProvider.deliveries.length} items',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Row(
          children: [
            IconButton(
              onPressed: deliveryProvider.currentPage == 1
                  ? null
                  : () => deliveryProvider.goToFirstPage(),
              icon: Icon(
                Icons.first_page,
                color: deliveryProvider.currentPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed: deliveryProvider.currentPage == 1
                  ? null
                  : () => deliveryProvider.goToPreviousPage(),
              icon: Icon(
                Icons.chevron_left,
                color: deliveryProvider.currentPage == 1
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Page ${deliveryProvider.currentPage} of ${deliveryProvider.totalPages}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              onPressed:
                  deliveryProvider.currentPage == deliveryProvider.totalPages
                  ? null
                  : () => deliveryProvider.goToNextPage(),
              icon: Icon(
                Icons.chevron_right,
                color:
                    deliveryProvider.currentPage == deliveryProvider.totalPages
                    ? Colors.grey
                    : AppTheme.primaryRetroModern,
              ),
            ),
            IconButton(
              onPressed:
                  deliveryProvider.currentPage == deliveryProvider.totalPages
                  ? null
                  : () => deliveryProvider.goToLastPage(),
              icon: Icon(
                Icons.last_page,
                color:
                    deliveryProvider.currentPage == deliveryProvider.totalPages
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

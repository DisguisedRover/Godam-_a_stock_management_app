import 'package:flutter/material.dart';

class NewAnalysisScreen extends StatefulWidget {
  const NewAnalysisScreen({super.key});

  @override
  State<NewAnalysisScreen> createState() => _NewAnalysisScreenState();
}

class _NewAnalysisScreenState extends State<NewAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _lactoseController = TextEditingController();
  final TextEditingController _snfController = TextEditingController();
  final TextEditingController _densityController = TextEditingController();

  void _performAnalysis() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would collect these values and send them to a service
      final fat = double.tryParse(_fatController.text) ?? 0.0;
      final protein = double.tryParse(_proteinController.text) ?? 0.0;
      final lactose = double.tryParse(_lactoseController.text) ?? 0.0;
      final snf = double.tryParse(_snfController.text) ?? 0.0;
      final density = double.tryParse(_densityController.text) ?? 0.0;

      // Simulate analysis process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Analysis submitted for Fat: $fat%, Protein: $protein%, Lactose: $lactose, SNF: $snf, Density: $density(Mock)',
          ),
        ),
      );

      // Clear fields after submission
      _fatController.clear();
      _proteinController.clear();
      _lactoseController.clear();
      _snfController.clear();
      _densityController.clear();

      // Optionally navigate back or show a success dialog
      // Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _fatController.dispose();
    _proteinController.dispose();
    _lactoseController.dispose();
    _snfController.dispose();
    _densityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Milk Analysis')),
      body: Center(
        child: SingleChildScrollView(
          // Allow scrolling if content overflows vertically
          padding: const EdgeInsets.all(30.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ), // Wider form for desktop
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Enter Milk Sample Details',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _fatController,
                        decoration: const InputDecoration(
                          labelText: 'Fat Percentage (%)',
                          hintText: 'e.g., 3.5',
                          prefixIcon: Icon(Icons.opacity),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter fat percentage';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _proteinController,
                        decoration: const InputDecoration(
                          labelText: 'Protein Percentage (%)',
                          hintText: 'e.g., 3.2',
                          prefixIcon: Icon(Icons.egg),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter protein percentage';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _lactoseController,
                        decoration: const InputDecoration(
                          labelText: 'Lactose Percentage (%)',
                          hintText: 'e.g., 4.8',
                          prefixIcon: Icon(Icons.water_drop),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter lactose percentage';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _snfController,
                        decoration: const InputDecoration(
                          labelText: 'SNF Percentage (%)',
                          hintText: 'e.g., 8.5',
                          prefixIcon: Icon(Icons.science),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter SNF percentage';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _densityController,
                        decoration: const InputDecoration(
                          labelText: 'Density (g/mL)',
                          hintText: 'e.g., 1.028',
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter density';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: _performAnalysis,
                        icon: const Icon(Icons.check),
                        label: const Text('Perform Analysis'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

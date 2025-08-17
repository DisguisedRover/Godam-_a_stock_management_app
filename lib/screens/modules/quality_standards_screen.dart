import 'package:flutter/material.dart';

class QualityStandardsScreen extends StatefulWidget {
  const QualityStandardsScreen({super.key});

  @override
  State<QualityStandardsScreen> createState() => _QualityStandardsScreenState();
}

class _QualityStandardsScreenState extends State<QualityStandardsScreen> {
  // Mock data for quality standards
  final Map<String, Map<String, double>> _standards = {
    'Fat': {'min': 3.5, 'max': 4.5},
    'Protein': {'min': 3.0, 'max': 3.8},
    'Lactose': {'min': 4.5, 'max': 5.2},
    'SNF': {'min': 8.0, 'max': 9.0},
    'Density': {'min': 1.028, 'max': 1.032},
  };

  bool _isEditing = false;

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveStandards() {
    // In a real app, send updated standards to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quality standards saved! (Mock)')),
    );
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quality Standards'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveStandards();
              } else {
                _toggleEditing();
              }
            },
            tooltip: _isEditing ? 'Save Standards' : 'Edit Standards',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Define Acceptable Milk Content Ranges',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    ..._standards.keys.map((key) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$key (% or Value)',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _standards[key]!['min']!
                                        .toStringAsFixed(2),
                                    decoration: InputDecoration(
                                      labelText: 'Minimum',
                                      prefixIcon: const Icon(
                                        Icons.arrow_downward,
                                      ),
                                      enabled: _isEditing,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _standards[key]!['min'] =
                                          double.tryParse(value) ??
                                          _standards[key]!['min']!;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _standards[key]!['max']!
                                        .toStringAsFixed(2),
                                    decoration: InputDecoration(
                                      labelText: 'Maximum',
                                      prefixIcon: const Icon(
                                        Icons.arrow_upward,
                                      ),
                                      enabled: _isEditing,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      _standards[key]!['max'] =
                                          double.tryParse(value) ??
                                          _standards[key]!['max']!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 30),
                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _saveStandards,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Save Standards'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

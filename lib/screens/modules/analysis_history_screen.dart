import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/milk_analysis_model.dart';
import '../../providers/milk_mock_data_provider.dart';

class AnalysisHistoryScreen extends StatelessWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MilkAnalysisResult> allAnalyses =
        MockDataProvider.getAllAnalyses();

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis History')),
      body: allAnalyses.isEmpty
          ? Center(
              child: Text(
                'No analysis data available.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0), // Consistent padding
              child: ListView.builder(
                itemCount: allAnalyses.length,
                itemBuilder: (context, index) {
                  final analysis = allAnalyses[index];
                  return _buildAnalysisResultCard(context, analysis);
                },
              ),
            ),
    );
  }

  Widget _buildAnalysisResultCard(
    BuildContext context,
    MilkAnalysisResult analysis,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15.0), // Spacing between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Theme.of(context).cardTheme.color,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing details for ${analysis.id}')),
          );
          // In a real app, navigate to a detail screen for this analysis
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Increased padding within card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analysis ID: ${analysis.id}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(analysis.date)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 16.0, // horizontal space between chips
                runSpacing: 10.0, // vertical space between lines of chips
                children: [
                  _buildInfoChip(
                    context,
                    'Fat',
                    '${analysis.fatPercentage.toStringAsFixed(2)}%',
                    Colors.orange,
                  ),
                  _buildInfoChip(
                    context,
                    'Protein',
                    '${analysis.proteinPercentage.toStringAsFixed(2)}%',
                    Colors.green,
                  ),
                  _buildInfoChip(
                    context,
                    'Lactose',
                    '${analysis.lactosePercentage.toStringAsFixed(2)}%',
                    Colors.blue,
                  ),
                  _buildInfoChip(
                    context,
                    'SNF',
                    '${analysis.snfPercentage.toStringAsFixed(2)}%',
                    Colors.purple,
                  ),
                  _buildInfoChip(
                    context,
                    'Density',
                    analysis.density.toStringAsFixed(3),
                    Colors.brown,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(Icons.info_outline, size: 20, color: color),
      ),
      label: Text(
        '$label: $value',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

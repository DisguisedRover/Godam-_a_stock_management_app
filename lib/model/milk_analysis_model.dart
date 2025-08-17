class MilkAnalysisResult {
  final String id;
  final DateTime date;
  final double fatPercentage;
  final double proteinPercentage;
  final double lactosePercentage;
  final double snfPercentage; // Solids-Non-Fat
  final double density; // kg/L or g/mL

  MilkAnalysisResult({
    required this.id,
    required this.date,
    required this.fatPercentage,
    required this.proteinPercentage,
    required this.lactosePercentage,
    required this.snfPercentage,
    required this.density,
  });

  // Factory constructor for generating mock data
  factory MilkAnalysisResult.generateMock(int index) {
    final now = DateTime.now();
    return MilkAnalysisResult(
      id: 'ANALYSIS-${1000 + index}',
      date: now.subtract(Duration(days: index * 2)), // Analyses every 2 days
      fatPercentage: 3.5 + (index % 5) * 0.1, // Varies between 3.5 and 3.9
      proteinPercentage: 3.2 + (index % 3) * 0.05, // Varies between 3.2 and 3.3
      lactosePercentage:
          4.8 + (index % 4) * 0.02, // Varies between 4.8 and 4.86
      snfPercentage: 8.5 + (index % 6) * 0.03, // Varies between 8.5 and 8.65
      density: 1.028 + (index % 7) * 0.001, // Varies between 1.028 and 1.034
    );
  }
}

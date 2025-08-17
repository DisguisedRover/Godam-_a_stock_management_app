import '../model/milk_analysis_model.dart';

class MockDataProvider {
  static List<MilkAnalysisResult> getRecentAnalyses(int count) {
    return List.generate(
      count,
      (index) => MilkAnalysisResult.generateMock(index),
    );
  }

  static List<MilkAnalysisResult> getAllAnalyses() {
    return List.generate(
      20,
      (index) => MilkAnalysisResult.generateMock(index),
    ); // More data for history
  }

  static double getAverageFat() {
    final all = getAllAnalyses();
    if (all.isEmpty) return 0.0;
    return all.map((e) => e.fatPercentage).reduce((a, b) => a + b) / all.length;
  }

  static double getAverageProtein() {
    final all = getAllAnalyses();
    if (all.isEmpty) return 0.0;
    return all.map((e) => e.proteinPercentage).reduce((a, b) => a + b) /
        all.length;
  }

  static double getAverageLactose() {
    final all = getAllAnalyses();
    if (all.isEmpty) return 0.0;
    return all.map((e) => e.lactosePercentage).reduce((a, b) => a + b) /
        all.length;
  }
}

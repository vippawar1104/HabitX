import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current theme brightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(8),
      child: HeatMap(
        startDate: startDate,
        endDate: DateTime.now().add(const Duration(days: 1)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        textColor: isDarkMode ? Colors.white : Colors.black, // Theme-aware text color
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color(0xFFB2DD9C), // Very light green
          2: Color(0xFF81C784), // Light green
          3: Color(0xFF4CAF50), // Medium green
          4: Color(0xFF388E3C), // Dark green
          5: Color(0xFF1B5E20), // Very dark green
        },
        onClick: (value) {
          debugPrint(value.toString());
        },
      ),
    );
  }

  static Map<DateTime, int> normalizeDataset(Map<DateTime, int> rawData) {
    final normalized = <DateTime, int>{};
    for (var entry in rawData.entries) {
      final dateOnly = DateTime(
        entry.key.year,
        entry.key.month,
        entry.key.day,
      );
      // Ensure value is between 1 and 5
      final normalizedValue = entry.value.clamp(1, 5);
      normalized[dateOnly] = normalizedValue;
    }
    return normalized;
  }
}

// Example usage with different values to test color variation
class HeatMapExample extends StatelessWidget {
  HeatMapExample({super.key});

  final Map<DateTime, int> dataset = {
    DateTime.now(): 5,                                            // Very dark green
    DateTime.now().subtract(const Duration(days: 1)): 4,         // Dark green
    DateTime.now().subtract(const Duration(days: 2)): 3,         // Medium green
    DateTime.now().subtract(const Duration(days: 3)): 2,         // Light green
    DateTime.now().subtract(const Duration(days: 4)): 1,         // Very light green
  };

  @override
  Widget build(BuildContext context) {
    return MyHeatMap(
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      datasets: MyHeatMap.normalizeDataset(dataset),
    );
  }
}
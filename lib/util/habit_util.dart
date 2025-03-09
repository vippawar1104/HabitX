// Check if the habit is completed today
import 'package:habitx/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();

  return completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

// Prepare heatmap dataset
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // Normalize date to avoid time mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // If the date already exists in the dataset, increment its count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        // Else initialize it with a count of 1
        dataset[normalizedDate] = 1;
      }
    }
  }
  return dataset;
}
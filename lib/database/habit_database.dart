import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitx/models/app_settings.dart';
import 'package:habitx/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*
  S E T U P 
  */

  // Initialize the database
  static Future<void> initialize(
      habitSchema, CollectionSchema<AppSettings> appSettingsSchema) async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [habitSchema, appSettingsSchema],
      directory: dir.path,
    );
  }

  // Save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get the first launch date for the heatmap
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*
  C R U D X O P E R A T I O N S
  */

  final List<Habit> currentHabits = [];

  // C R E A T E - add a new habit
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;

    // Save the habit to the database
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // Re-read the habits after adding the new one
    await readHabits();
  }

  // R E A D - read saved habits from the database
  Future<void> readHabits() async {
    final fetchedHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    notifyListeners();
  }

  // U P D A T E - check habit completion status (on and off)
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();

        // If habit is completed, add the current date to the completedDays list
        if (isCompleted && !habit.completedDays.contains(today)) {
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          // If habit is not completed, remove the current date from the list
          habit.completedDays.removeWhere((date) =>
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day);
        }

        // Save the updated habit back to the database
        await isar.habits.put(habit);
      });

      // Re-read from database after updating the habit
      await readHabits();
    }
  }

  // U P D A T E - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;

        // Save the updated habit back to the database
        await isar.habits.put(habit);
      });

      // Re-read the habits after updating the name
      await readHabits();
    }
  }

  // D E L E T E - delete habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // Re-read the habits after deleting the habit
    await readHabits();
  }

  // Get completed days for the heatmap dataset
  Map<DateTime, int> getHeatmapData() {
    final Map<DateTime, int> heatmapData = {};

    // Loop through all habits and add completed days to the heatmap data
    for (var habit in currentHabits) {
      for (var completedDate in habit.completedDays) {
        final date = DateTime(completedDate.year, completedDate.month, completedDate.day);
        heatmapData[date] = (heatmapData[date] ?? 0) + 1;  // Increment count for that date
      }
    }

    return heatmapData;
  }
}
import 'package:flutter/material.dart';
import 'package:habitx/components/my_drawer.dart';
import 'package:habitx/components/my_habit_tile.dart';
import 'package:habitx/components/my_heat_map.dart';
import 'package:habitx/database/habit_database.dart';
import 'package:habitx/models/habit.dart';
import 'package:habitx/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  // Text controller
  final TextEditingController textcontroller = TextEditingController();

  // Create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textcontroller,
          decoration: const InputDecoration(
            hintText: "Create a new habit",
          ),
        ),
        actions: [
          // Save button
          TextButton(
            onPressed: () {
              String newHabitName = textcontroller.text;

              // Save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              // Pop box
              Navigator.pop(context);

              // Clear controller
              textcontroller.clear();
            },
            child: const Text("Save"),
          ),

          // Cancel button
          TextButton(
            onPressed: () {
              // Pop box
              Navigator.pop(context);

              // Clear controller
              textcontroller.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Check habit on/off
  void checkHabitOnOff(bool? value, Habit habit) {
    // Update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // Edit habit box
  void editHabitBox(Habit habit) {
    // Set the controller's text to the habit's current name
    textcontroller.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textcontroller),
        actions: [
          // Save button
          TextButton(
            onPressed: () {
              String newHabitName = textcontroller.text;

              // Save to db
              context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);

              // Pop box
              Navigator.pop(context);

              // Clear controller
              textcontroller.clear();
            },
            child: const Text("Save"),
          ),

          // Cancel button
          TextButton(
            onPressed: () {
              // Pop box
              Navigator.pop(context);

              // Clear controller
              textcontroller.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          // Delete button
          MaterialButton(
            onPressed: () {
              // Delete from db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // Pop box
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),

          // Cancel button
          TextButton(
            onPressed: () {
              // Pop box
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: ListView(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              "HabitX",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Heatmap
          _buildHeatMap(),
          // Habit list
          _buildHabitList(),
        ],
      ),
    );
  }

  // Build heat map
  Widget _buildHeatMap() {
    // Habit database
    final habitDatabase = context.watch<HabitDatabase>();

    // Current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Return heat map UI
    return FutureBuilder<DateTime>(
      future: habitDatabase.getFirstLaunchDate().then((date) => date ?? DateTime.now()),
      builder: (context, snapshot) {
        // Once the data is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        }
        // Handle case where no data is returned
        else {
          return Container();
        }
      },
    );
  }

  // Build habit list
  Widget _buildHabitList() {
    // Habit db
    final habitDatabase = context.watch<HabitDatabase>();

    // Current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // Get each individual habit
        final habit = currentHabits[index];

        // Check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // Return habit tile UI
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
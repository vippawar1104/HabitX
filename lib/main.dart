import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitx/database/habit_database.dart';
import 'package:habitx/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'models/app_settings.dart';
import 'models/habit.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Correct initialization of the HabitDatabase
  await HabitDatabase.initialize(HabitSchema, AppSettingsSchema);  // Fixed line

  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(
      providers: [
        // Habit provider
        ChangeNotifierProvider(create: (context) => HabitDatabase()),

        // Theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData, // Fixed error
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitx/pages/challenges.dart';
import 'package:habitx/pages/statistics_page.dart';
import 'package:habitx/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Drawer header with app logo/name
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.track_changes_rounded,
                    size: 65,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'HabitX',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Drawer items
          Expanded(
            child: ListView(
              children: [
                // Theme toggle
                ListTile(
                  leading: Icon(
                    Provider.of<ThemeProvider>(context).isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(),
                  ),
                ),

                // Divider
                Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.2),
                ),

                // Statistics
                ListTile(
                  leading: Icon(
                    Icons.bar_chart,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                  title: Text(
                    'Statistics',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsPage(),
                      ),
                    );
                  },
                ),

                // Challenges
                ListTile(
                  leading: Icon(
                    Icons.emoji_events,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                  title: Text(
                    'Challenges',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Join community challenges',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.7),
                    ),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);  // Close the drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChallengesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom section with app version
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
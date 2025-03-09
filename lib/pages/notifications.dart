import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class CustomNotification {
  final String title;
  final String message;
  final DateTime timestamp;

  CustomNotification({
    required this.title,
    required this.message,
    required this.timestamp,
  });
}

class Habit {
  final String name;
  bool isCompleted;

  Habit({
    required this.name,
    this.isCompleted = false,
  });
}

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({Key? key}) : super(key: key);

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final List<Habit> habits = [
    Habit(name: 'Morning Exercise'),
    Habit(name: 'Read 30 minutes'),
    Habit(name: 'Meditation'),
    Habit(name: 'Drink Water'),
  ];

  final List<CustomNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    _initializeTimeZones();
    _initializeNotifications();
    _scheduleDailyReminder();
  }

  Future<void> _initializeTimeZones() async {
    tz.initializeTimeZones();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );

    // Request permissions for iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _scheduleDailyReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_reminders',
      'Habit Reminders',
      channelDescription: 'Daily reminders for habits',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Habit Reminder',
      'Don\'t forget to complete your habits for today!',
      _nextInstanceOf8AM(),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOf8AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8, // 8 AM
    );
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _showCompletionNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_completion',
      'Habit Completion',
      channelDescription: 'Notifications for completed habits',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      'All Habits Completed!',
      'Congratulations! You\'ve completed all your habits for today! 🎉',
      platformChannelSpecifics,
    );
  }

  bool _areAllHabitsCompleted() {
    return habits.every((habit) => habit.isCompleted);
  }

  void _checkHabitCompletion() {
    if (_areAllHabitsCompleted()) {
      setState(() {
        notifications.insert(
          0,
          CustomNotification(
            title: 'All Habits Completed!',
            message: 'Congratulations! You\'ve completed all your habits for today.',
            timestamp: DateTime.now(),
          ),
        );
      });
      _showCompletionNotification();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Habit Tracker'),
          backgroundColor: Colors.blue,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Habits'),
              Tab(text: 'Notifications'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHabitsList(),
            _buildNotificationsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            title: Text(habit.name),
            value: habit.isCompleted,
            onChanged: (bool? value) {
              setState(() {
                habit.isCompleted = value ?? false;
                _checkHabitCompletion();
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationsList() {
    return notifications.isEmpty
        ? const Center(
            child: Text('No notifications yet'),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(notification.message),
                  trailing: Text(
                    _formatTimestamp(notification.timestamp),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HabitTrackerPage(),
    ),
  );
}
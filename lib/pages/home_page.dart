import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box<Habit> habitBox = Hive.box<Habit>('habits');
  final Box<AppSettings> settingsBox = Hive.box<AppSettings>('settings');
  final HabitDatabase db = HabitDatabase();

  @override
  void initState() {
    super.initState();
    // Initialize the habit database
    if (habitBox.isEmpty) {
      db.addHabit('Habit 1');
    }
    db.readHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 3),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.add),
      ),
    );
  }
}

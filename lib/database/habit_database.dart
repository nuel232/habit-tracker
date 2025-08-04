import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/models/app_settings.dart';

class HabitDatabase extends ChangeNotifier {
  final Box<Habit> _habitBox = Hive.box<Habit>('habits');
  final Box<AppSettings> _settingsBox = Hive.box<AppSettings>('settings');

  //List of habits
  List<Habit> currentHabits = [];

  // S E T U P

  // Save first date of app startup (for heatmap)
  static Future<void> saveFirstLaunchDate() async {
    final settingsBox = Hive.box<AppSettings>('settings');
    if (settingsBox.isEmpty) {
      await settingsBox.put(
        'first',
        AppSettings(firstLaunchDate: DateTime.now()),
      );
    }
  }

  // Get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = _settingsBox.get('first');
    return settings?.firstLaunchDate;
  }

  /*
  C R U D   O P E R A T I O N S
  */

  // C R E A T E
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit(name: habitName);

    // Add habit to database (Hive auto-generates the key)
    await _habitBox.add(newHabit);

    // Re-read from db
    await readHabits();
  }

  // R E A D
  Future<void> readHabits() async {
    // Fetch all habits from the database
    currentHabits = _habitBox.values.toList();

    // Update UI
    notifyListeners();
  }

  // U P D A T E - check habit on and off
  Future<void> updateHabitCompletion(int key, bool isCompleted) async {
    // Find the specific habit using its Hive key
    final habit = _habitBox.get(key);

    if (habit != null) {
      // Get today's date (date only)
      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);

      // If habit is completed -> add the current date to the completed list
      // If not -> remove the date
      // habit.completedDays.add(todayDateOnly);

      if (isCompleted && !habit.completedDays.contains(todayDateOnly)) {
        habit.completedDays.add(todayDateOnly);
      } else {
        habit.completedDays.remove(todayDateOnly);
      }

      // Save the updated habit back to the database
      await habit.save();
    }

    // Re-read from db
    await readHabits();
  }

  // U P D A T E - edit habit name
  Future<void> updateHabitName(int key, String newName) async {
    // Find the specific habit
    final habit = _habitBox.get(key);

    // Update habit name
    if (habit != null) {
      habit.name = newName;

      // Save updated habit back to db
      await habit.save();
    }

    // Re-read from db
    await readHabits();
  }

  // D E L E T E
  Future<void> removeHabit(int key) async {
    // Perform the delete
    await _habitBox.delete(key);

    // Re-read from db
    await readHabits();
  }
}

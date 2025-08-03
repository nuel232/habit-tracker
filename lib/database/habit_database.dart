import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  //S E T U P

  //I N I T I A L I Z E - D A TA B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  //save first date of app start up (for heatmap)
  static Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*
  C R U D O P E R A T I O N S
  */

  //List of habits
  List<Habit> currentHabits = [];

  //C R E A T E
  Future<void> addHabit(String HabitName) async {
    final newHabit = Habit()..name = HabitName;

    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re-read from db
    readHabit();
  }

  // R E A D

  Future<void> readHabit() async {
    //fetch all habit from he database
    List<Habit> fetchedhabits = await isar.habits.where().findAll();

    //give to current habits
    currentHabits.clear();

    //add all to current habit
    currentHabits.addAll(fetchedhabits);

    //update UI
    notifyListeners();
  }

  //U P D A T E - check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find the specific habit
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        //today
        final today = DateTime.now();

        final todayDateOnly = DateTime(today.year, today.month, today.day);

        //if habit is completed -> add the current date to the completedDays list
        if (isCompleted && !habit.completedDays.contains(todayDateOnly)) {
          //add the current date if it's not already in the list
          habit.completedDays.add(todayDateOnly);
        }
        //if habit is NOT completed -> remove the current date from the list
        else {
          //remove the current date if the habit has been marked as not completed
          habit.completedDays.remove(todayDateOnly);
        }

        //save the update habits back to the database
        await isar.habits.put(habit);
      });
    }
    //re-read from db
    readHabit();
  }

  //U P D A T E - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    //find the specific habit
    final habit = await isar.habits.get(id);

    //update habit name
    if (habit != null) {
      //update name
      await isar.writeTxn(() async {
        habit.name = newName;
        //save updated habit hack to the db
        await isar.habits.put(habit);
      });
    }

    //re-read from db
    readHabit();
  }

  //D E L E T E
  Future<void> removeHabit(int id) async {
    //perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    //re-read from db
    readHabit();
  }
}

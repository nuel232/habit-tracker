import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Box<Habit> habitBox;
  late final Box<AppSettings> settingsBox;
  late final HabitDatabase db;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      db = Provider.of<HabitDatabase>(context, listen: false);
      if (db.currentHabits.isEmpty) {
        db.addHabit('Habit 1');
      }
      db.readHabits();
    });
  }

  //text controller
  final TextEditingController textController = TextEditingController();

  //create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Create a new habit'),
        ),
        actions: [
          //save button
          MaterialButton(
            child: Text('save'),
            onPressed: () {
              String newHabitName = textController.text;

              //save to db
              db.addHabit(newHabitName);

              //pop box
              Navigator.pop(context);

              //clear text controller
              textController.clear();
            },
          ),

          //cancel button
          MaterialButton(
            child: Text('Cancel'),
            onPressed: () {
              //pop box
              Navigator.pop(context);

              //clear text controller
              textController.clear();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.add),
      ),

      body: _buildHabitList(),
    );
  }

  Widget _buildHabitList() {
    //currents habits
    List<Habit> currentHabits = db.currentHabits;

    //return list
    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        //get each individual habit
        final habit = currentHabits[index];

        //check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        //return habit tile UI
        return ListTile(title: Text(habit.name));
      },
    );
  }
}

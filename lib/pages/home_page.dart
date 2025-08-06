import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controller
  final TextEditingController textController = TextEditingController();

  // Cache the first launch date to prevent unnecessary rebuilds
  DateTime? _cachedFirstLaunchDate;
  bool _isLoadingFirstLaunchDate = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      if (!mounted) return;
      final db = Provider.of<HabitDatabase>(context, listen: false);

      // Load habits and first launch date simultaneously
      await Future.wait([db.readHabits(), _loadFirstLaunchDate(db)]);
    });
  }

  Future<void> _loadFirstLaunchDate(HabitDatabase db) async {
    final firstLaunchDate = await db.getFirstLaunchDate();
    if (mounted) {
      setState(() {
        _cachedFirstLaunchDate = firstLaunchDate;
        _isLoadingFirstLaunchDate = false;
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

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
          TextButton(
            child: Text('save'),
            onPressed: () {
              String newHabitName = textController.text;

              if (newHabitName.isNotEmpty) {
                //save to db
                final db = Provider.of<HabitDatabase>(context, listen: false);
                db.addHabit(newHabitName);
              }

              //pop box
              Navigator.pop(context);

              //clear text controller
              textController.clear();
            },
          ),

          //cancel button
          TextButton(
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

  //check habit on nd off
  void checkHabitOnOff(BuildContext context, bool? value, Habit habit) {
    //update the habit completion status
    if (value != null) {
      final db = Provider.of<HabitDatabase>(context, listen: false);
      db.updateHabitCompletion(habit.key, value);
    }
  }

  //edit habit box
  void editHabitBox(Habit habit) {
    //set the controller's test to the habit's current name
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          //save button
          TextButton(
            child: Text('save'),
            onPressed: () {
              String newHabitName = textController.text;

              if (newHabitName.isNotEmpty) {
                //save to db
                final db = Provider.of<HabitDatabase>(context, listen: false);
                db.updateHabitName(habit.key, newHabitName);
              }

              //pop box
              Navigator.pop(context);

              //clear text controller
              textController.clear();
            },
          ),

          //cancel button
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              //pop box
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to delete this habit'),
        actions: [
          //delete button
          TextButton(
            child: Text('delete'),
            onPressed: () {
              //save to db
              final db = Provider.of<HabitDatabase>(context, listen: false);
              db.removeHabit(habit.key);

              //pop box
              Navigator.pop(context);
            },
          ),

          //cancel button
          TextButton(
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
      appBar: AppBar(backgroundColor: Colors.transparent),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface),
      ),
      body: ListView(
        children: [
          //heat map
          _buildHeatMap(),

          //habit list
          Consumer<HabitDatabase>(
            builder: (context, db, child) {
              return _buildHabitList(db.currentHabits);
            },
          ),
        ],
      ),
    );
  }

  //build heat map - now uses cached data to prevent flicker
  Widget _buildHeatMap() {
    // If we're still loading, show a placeholder
    if (_isLoadingFirstLaunchDate) {
      return SizedBox(
        height: 200, // Fixed height to prevent layout shifts
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // If we don't have a first launch date, show empty container
    if (_cachedFirstLaunchDate == null) {
      return Container(height: 200);
    }

    // Use Consumer to get real-time habit updates but with cached start date
    return Consumer<HabitDatabase>(
      builder: (context, db, child) {
        return MyHeatMap(
          startDate: _cachedFirstLaunchDate!,
          datasets: preHeatMapDataset(db.currentHabits),
        );
      },
    );
  }

  //build habit list
  Widget _buildHabitList(List<Habit> currentHabits) {
    //return list
    return ListView.builder(
      itemCount: currentHabits.length,
      //when you have a list inside another list like nested list you might have problems scrolling
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        //get each individual habit
        final habit = currentHabits[index];

        //check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        //return habit tile UI
        return MyHabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(context, value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}

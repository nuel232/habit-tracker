import 'package:isar/isar.dart';

//run flutter pub run build_runner build
part 'habit.g.dart';

@collection
class Habit {
  //habit id
  Id id = Isar.autoIncrement;

  //habit name
  late String name;

  //completed days

  List<DateTime> completedDays = [];
}

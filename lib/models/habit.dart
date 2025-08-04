import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<DateTime> completedDays;

  Habit({required this.name, List<DateTime>? completedDays})
    : completedDays = completedDays ?? [];
}

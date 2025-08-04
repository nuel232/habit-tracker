import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 0)
class AppSettings {
  @HiveField(0)
  DateTime? firstLaunchDate;

  AppSettings({this.firstLaunchDate});
}

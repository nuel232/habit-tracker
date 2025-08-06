import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int>? datasets;
  const MyHeatMap({super.key, required this.startDate, required this.datasets});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      //then our start date and end date
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.tertiary,
      textColor: Theme.of(context).colorScheme.onSurface,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 38,
      //first have to define our color sets
      colorsets: {
        1: Colors.deepPurple.shade100,
        2: Colors.deepPurple.shade300,
        3: Colors.deepPurple.shade500,
        4: Colors.deepPurple.shade700,
        5: Colors.deepPurple.shade900,
      },
    );
  }
}

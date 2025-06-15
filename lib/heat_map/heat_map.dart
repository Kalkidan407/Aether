import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapPage extends StatelessWidget {
  final ScrollController scrollController;

  const HeatMapPage({Key? key, required this.scrollController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Your Task Heatmap",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          HeatMapCalendar(
            size: 42,
            borderRadius: 1,
            datasets: {
              DateTime.now().subtract(Duration(days: 1)): 3,
              DateTime.now(): 5,
            },
            colorsets: {
              1: Colors.green[100]!,
              3: Colors.green[400]!,
              5: Colors.green[700]!,
            },
            onClick: (date) => print("Clicked $date"),
          ),
          // const SizedBox(height: 400),
        ],
      ),
    );
  }
}

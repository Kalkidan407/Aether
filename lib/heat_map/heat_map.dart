import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:kuraztest/heat_map/heatmap_data_provider.dart';
import 'package:provider/provider.dart';

class HeatMapPage extends StatelessWidget {
  final ScrollController scrollController;

  HeatMapPage({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heatmapData = Provider.of<HeatmapDataProvider>(context);

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Text(
            "Your Task Heatmap",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 26),
          HeatMapCalendar(
            datasets: heatmapData.dataset,
            size: 25, // Small square like GitHub
            fontSize: 10.0,

            textColor: const Color.fromARGB(0, 233, 225, 225),
            margin: EdgeInsets.all(2),
            borderRadius: 5,
            colorsets: {
              1: const Color.fromARGB(255, 129, 180, 131),
              2: const Color.fromARGB(255, 93, 172, 95),
              3: const Color.fromARGB(255, 77, 181, 81),
              4: const Color.fromARGB(255, 60, 181, 64),
              5: const Color.fromARGB(255, 15, 171, 20),
            },
            colorTipCount: 5,
            colorTipHelper: [Text("Low"), Text("Medium"), Text("High")],
            colorMode: ColorMode.opacity,
            showColorTip: true,

            initDate: DateTime.now(),
            monthFontSize: 10,
            weekFontSize: 10,
            weekTextColor: Colors.grey[500],
            defaultColor: const Color.fromARGB(255, 233, 229, 214),
          ),

          // const SizedBox(height: 400),
        ],
      ),
    );
  }
}

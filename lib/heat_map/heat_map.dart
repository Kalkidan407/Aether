import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:kuraztest/heat_map/heatmap_data_provider.dart';
import 'package:provider/provider.dart';

class HeatMapPage extends StatelessWidget {
  final ScrollController scrollController;

  HeatMapPage({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final heatmapData = Provider.of<HeatmapDataProvider>(context);
    final heapMapData = context.watch<HeatmapDataProvider>().data;
    print('dataset value: $heapMapData');

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
            datasets: heapMapData,
            size: 35,

            borderRadius: 6,
            colorsets: {
              1: const Color.fromARGB(255, 168, 211, 170),
              2: const Color.fromARGB(255, 129, 193, 131),
              3: const Color.fromARGB(255, 97, 174, 101),
              4: const Color.fromARGB(255, 80, 180, 85),
              5: const Color.fromARGB(255, 14, 164, 19),
            },
            colorTipHelper: [Text("Low "), Text("   High")],
            colorMode: ColorMode.color,
            showColorTip: true,
            onClick: (date) {
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text('Clicked on $date')));
            },
            initDate: DateTime.now(),
            monthFontSize: 10,
            weekFontSize: 10,
            weekTextColor: Colors.grey[500],
            defaultColor: const Color.fromARGB(93, 205, 205, 102),
          ),

          // const SizedBox(height: 400),
        ],
      ),
    );
  }
}

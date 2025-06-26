// import 'package:flutter/material.dart';
// import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
// import 'package:kuraztest/heat_map/heatmap_data_provider.dart';
// import 'package:provider/provider.dart';

// class HeatMapPage extends StatelessWidget {
//   final ScrollController scrollController;

//   HeatMapPage({Key? key, required this.scrollController}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // final heatmapData = Provider.of<HeatmapDataProvider>(context);
//     final heapMapData = context.watch<HeatmapDataProvider>().data;
//     print('dataset value: $heapMapData');

//     return SingleChildScrollView(
//       controller: scrollController,
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SizedBox(height: 15),
//           Text(
//             "Your Task Heatmap",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 26),
//           HeatMapCalendar(
//             datasets: heapMapData,
//             size: 35,

//             borderRadius: 6,
//             colorsets: {
//               1: const Color.fromARGB(255, 168, 211, 170),
//               2: const Color.fromARGB(255, 129, 193, 131),
//               3: const Color.fromARGB(255, 97, 174, 101),
//               4: const Color.fromARGB(255, 80, 180, 85),
//               5: const Color.fromARGB(255, 14, 164, 19),
//             },
//             colorTipHelper: [Text("Low "), Text("   High")],
//             colorMode: ColorMode.color,
//             showColorTip: true,
//             onClick: (date) {
//               // ScaffoldMessenger.of(
//               //   context,
//               // ).showSnackBar(SnackBar(content: Text('Clicked on $date')));
//             },
//             initDate: DateTime.now(),
//             monthFontSize: 10,
//             weekFontSize: 10,
//             weekTextColor: Colors.grey[500],
//             defaultColor: const Color.fromARGB(93, 205, 205, 102),
//           ),

//           // const SizedBox(height: 400),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:isar/isar.dart';
import 'package:kuraztest/models/task.dart';

class HeatMapPage extends StatefulWidget {
  final ScrollController scrollController;

  HeatMapPage({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<HeatMapPage> createState() => _HeatMapPageState();
}

class _HeatMapPageState extends State<HeatMapPage> {
  // Normalize the DateTime to remove time info (just keep date)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Build the heatmap data by grouping tasks done by date
  Future<Map<DateTime, int>> _buildHeatmapData() async {
    final isar = Isar.getInstance(); // or use your isar service
    final completedTasks = await isar!.tasks
        .filter()
        .isDoneEqualTo(true)
        .findAll();

    final Map<DateTime, int> heatmapData = {};

    for (final task in completedTasks) {
      if (task.deadline != null ) {
        final date = _normalizeDate(task.startTime ?? task.deadline ??  DateTime.now());

if (date.isBefore(DateTime.now()) || date.isAtSameMomentAs(DateTime.now())) {
  heatmapData[date] = (heatmapData[date] ?? 0) + 1;
}

        
      }
    }

    return heatmapData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, int>>(
      future: _buildHeatmapData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final heatmapData = snapshot.data!;
        print('🔥 Heatmap data: $heatmapData');

        return SingleChildScrollView(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                "Your Task Heatmap",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 26),
              HeatMapCalendar(
                datasets: heatmapData,
                size: 35,
                borderRadius: 6,
                colorsets: {
                  1: const Color.fromARGB(255, 150, 202, 152),
                  2: const Color.fromARGB(255, 119, 190, 121),
                  3: const Color.fromARGB(255, 86, 170, 90),
                  4: const Color.fromARGB(255, 66, 175, 72),
                  5: const Color.fromARGB(255, 12, 162, 17),
                },
                colorTipHelper: const [Text("Low "), Text("   High")],
                colorMode: ColorMode.color,
                showColorTip: true,
                initDate: DateTime.now(),
                monthFontSize: 10,
                weekFontSize: 10,
                weekTextColor: Colors.grey[500],
                defaultColor: const Color.fromARGB(93, 205, 205, 102),
              ),
            ],
          ),
        );
      },
    );
  }
}

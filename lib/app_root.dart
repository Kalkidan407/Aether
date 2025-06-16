import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kuraztest/task/task.dart';
import 'package:kuraztest/heat_map/heatmap_data_provider.dart';

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HeatmapDataProvider(),
      child: TaskList(), // ✅ This now has access to your provider
    );
  }
}

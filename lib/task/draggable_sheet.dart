import 'package:flutter/material.dart';
import 'package:kuraztest/heat_map/heat_map.dart';

void showDraggableSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder:
        (context) => DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.9,

          expand: false,
          builder: (context, scrollController) {
            return HeatMapPage(scrollController: scrollController);
          },
        ),
  );
}

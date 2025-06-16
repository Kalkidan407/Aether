import 'package:flutter/material.dart';
import 'package:kuraztest/heat_map/heat_map.dart';

void showDraggableSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color.fromARGB(255, 239, 239, 239),
    builder:
        (context) => Builder(
          builder:
              (newContext) => DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) {
                  return Container(
                    width: double.infinity,
                    child: HeatMapPage(scrollController: scrollController),
                  );
                },
              ),
        ),
  );
}

// for (final task in completedTasks) {
//   final date = _normalizeDate(
//     task.startTime ?? task.deadline ?? task.createdAt ?? task.updatedAt ?? DateTime.now()
//   );
//   heatmapData[date] = (heatmapData[date] ?? 0) + 1;
// }


// if (date.isBefore(DateTime.now()) || date.isAtSameMomentAs(DateTime.now())) {
//   heatmapData[date] = (heatmapData[date] ?? 0) + 1;
// }



import 'package:kuraztest/gemini_service.dart';

final geminiService = GeminiService();

void _handleTaskInput(String userInput) async {
  final extracted = await geminiService.extractDeadline(userInput);
  print("🧠 Gemini says: $extracted");

  // You can then parse the date and set it to your task
}

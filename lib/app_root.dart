// Future<(int total, int completed)> getTodayTaskStatus() async {
//   final now = DateTime.now();
//   final startOfDay = DateTime(now.year, now.month, now.day);
//   final endOfDay = startOfDay.add(Duration(days: 1));

//   final isar = Isar.getInstance();

//   final tasks = await isar!.tasks
//       .filter()
//       .deadlineGreaterThan(startOfDay)
//       .deadlineLessThan(endOfDay)
//       .findAll();

//   final completed = tasks.where((t) => t.isCompleted).length;

//   return (tasks.length, completed);
// }


//.deadlineBetween(startOfDay, endOfDay)


// Future<String> getMotivationalMessage(int completed, int total) async {
//   final prompt = "The user has completed $completed out of $total tasks today. "
//                  "Send a short, positive motivational message.";

//   final response = await http.post(
//     Uri.parse("https://api.openai.com/v1/chat/completions"),
//     headers: {
//       "Authorization": "Bearer ${dotenv.env['OPENAI_API_KEY']}",
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode({
//       "model": "gpt-3.5-turbo",
//       "messages": [{"role": "user", "content": prompt}],
//     }),
//   );

//   final data = jsonDecode(response.body);
//   return data['choices'][0]['message']['content'];
// }


// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<String> getMotivationalMessage(int completed, int total) async {
//   final prompt =
//       "The user has completed $completed out of $total tasks today. Send a motivational message.";

//   final response = await http.post(
//     Uri.parse("https://api.openai.com/v1/chat/completions"),
//     headers: {
//       "Authorization": "Bearer YOUR_OPENAI_KEY_HERE",
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode({
//       "model": "gpt-3.5-turbo",
//       "messages": [{"role": "user", "content": prompt}],
//     }),
//   );

//   final data = jsonDecode(response.body);
//   return data['choices'][0]['message']['content'];
// }




// class TaskSummaryWidget extends StatefulWidget {
//   @override
//   _TaskSummaryWidgetState createState() => _TaskSummaryWidgetState();
// }

// class _TaskSummaryWidgetState extends State<TaskSummaryWidget> {
//   String summaryMessage = "Loading...";

//   @override
//   void initState() {
//     super.initState();
//     loadSummary();
//   }

//   Future<void> loadSummary() async {
//     final (total, completed) = await getTodayTaskStatus();
//     final msg = await getMotivationalMessage(completed, total);
//     setState(() {
//       summaryMessage = msg;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       summaryMessage,
//       style: TextStyle(fontSize: 16),
//     );
//   }
// }




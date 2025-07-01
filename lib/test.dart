// for (final task in completedTasks) {
//   final date = _normalizeDate(
//     task.startTime ?? task.deadline ?? task.createdAt ?? task.updatedAt ?? DateTime.now()
//   );
//   heatmapData[date] = (heatmapData[date] ?? 0) + 1;
// }


// if (date.isBefore(DateTime.now()) || date.isAtSameMomentAs(DateTime.now())) {
//   heatmapData[date] = (heatmapData[date] ?? 0) + 1;
// }


// import 'package:google_generative_ai/google_generative_ai.dart';

// // Access your API key as an environment variable (see the API Key section)
// final apiKey = String.fromEnvironment('API_KEY');

// // For text-only input
// final model = GenerativeModel(
//   model: 'gemini-2.5-flash-preview-04-17', // or gemini-1.5-pro
//   apiKey: apiKey,
// );

// Container(
//   width: 180,
// margin: EdgeInsets.only(right: 120),
// alignment: Alignment.centerLeft,
//   child: Text( 
//    summaryMessage ,   
//    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900 )
//   )



import 'package:kuraztest/gemini_service.dart';

final geminiService = GeminiService();

void _handleTaskInput(String userInput) async {
  final extracted = await geminiService.extractDeadline(userInput);
  print("🧠 Gemini says: $extracted");

  // You can then parse the date and set it to your task
}

//[ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: LateInitializationError: Field '_dbFuture@38284795' has not been initialized.



// Future<String> getMotivationalMessage(int completed, int total) async {
//   final apiKey = dotenv.env['API_KEY'] ?? '';
//   final prompt = "The user has completed $completed out of $total tasks today. "
//                  "Send a short, positive motivational message.";

//   final url = Uri.parse(
//     'https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=$apiKey'
//   );

//   final requestBody = {
//     "prompt": {
//       "messages": [
//         {"content": prompt, "author": "user"}
//       ]
//     },
//     "temperature": 0.7
//   };

//   final response = await http.post(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(requestBody),
//   );

//   print('🔄 Status Code: ${response.statusCode}');
//   print('📦 Body: ${response.body}');

//   if (response.statusCode != 200) {
//     return "Error fetching message.";
//   }

//   final data = jsonDecode(response.body);
//   print('✅ Decoded Data: $data');

//   final message = data['candidates'][0]['content'];
//   return message;
// }


// final url = Uri.parse(
//   'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey'
// );

// final requestBody = {
//   "contents": [
//     {
//       "parts": [
//         {
//           "text": prompt
//         }
//       ]
//     }
//   ]
// };


//  final url = Uri.parse(
//     'https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=$apiKey'
//   );

//   final requestBody = {
//     "prompt": {
//       "messages": [
//         {"content": prompt, "author": "user"}
//       ]
//     },
//     "temperature": 0.7,
//     //"max_output_tokens": 100
    
//   };

//   final response = await http.post (
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(requestBody),
//   );




// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart'; // Make sure this is imported

// // ... other imports and class definition

// class _TaskListState extends State<TaskList> {
//   final apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'ERROR '; // This looks correct if .env is loaded
//   String summaryMessage = "Loading...";
//   // ... rest of your state variables

//   // ... initState and other methods

//   Future<String> getMotivationalMessage(int completed, int total) async {
//     // Construct the prompt based on your needs
//     final String prompt = "The user has completed $completed out of $total tasks today. "
//                           "Send a short, positive motivational message.";

//     // **CHANGED:** Gemini API endpoint and model
//     final url = Uri.parse(
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
//     );

//     // **CHANGED:** Request body format for Gemini
//     final requestBody = {
//       "contents": [
//         {
//           "role": "user",
//           "parts": [
//             {"text": prompt}
//           ]
//         }
//       ],
//       "generationConfig": {
//         "temperature": 0.7,
//         "maxOutputTokens": 100, // Optional: Limit response length
//       },
//       // You can also add safetySettings here if needed
//       // "safetySettings": [
//       //   {
//       //     "category": "HARM_CATEGORY_HARASSMENT",
//       //     "threshold": "BLOCK_NONE"
//       //   }
//       // ]
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );

//       print('🔄 Status Code: ${response.statusCode}');
//       print('📦 Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         // **CHANGED:** Accessing the text content in Gemini response
//         // Ensure to handle cases where 'candidates', 'content', 'parts' might be missing
//         if ( data['candidates'] != null &&
//             data['candidates'].isNotEmpty &&
//             data['candidates'][0]['content'] != null &&
//             data['candidates'][0]['content']['parts'] != null &&
//             data['candidates'][0]['content']['parts'].isNotEmpty &&
//             data['candidates'][0]['content']['parts'][0]['text'] != null) {
//           final message = data['candidates'][0]['content']['parts'][0]['text'];
//           return message;
//         } else {
//           print('Error: Unexpected Gemini API response format.');
//           return "Couldn't get a message. Try again!";
//         }
//       } else {
//         // Log the error for debugging
//         print('Error response from Gemini API: ${response.statusCode} - ${response.body}');
//         return "Error fetching message: ${response.statusCode}";
//       }
//     } catch (e) {
//       print('Exception during API call: $e');
//       return "Network error or API call failed: ${e.toString()}";
//     }
//   }

//   // ... rest of your TaskListState class
// }








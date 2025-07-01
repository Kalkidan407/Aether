import 'package:google_generative_ai/google_generative_ai.dart';


final apiKey = String.fromEnvironment('API_KEY');

class GeminiService {
  final  model = GenerativeModel (
    model:'gemini-2.5-flash-preview-04-17' ,
    apiKey: apiKey, 
  );

  Future<String> extractDeadline(String inputText) async {
    try {
      final content = [Content.text('Extract the deadline from: "$inputText"')];
      final response = await model.generateContent(content);
      return response.text ?? "No deadline found.";
    } catch (e) {
      return "Error: $e";
    }
  }
}

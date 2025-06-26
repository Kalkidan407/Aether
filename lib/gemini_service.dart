import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyCcao5jLaozEq_Z7cw82y8cSPcssBIcpCE', 
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

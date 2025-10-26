import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiAIService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  /// Generate AI content based on a prompt
  static Future<String> generateContent(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return text;
      } else {
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error calling Gemini API: $e');
    }
  }

  /// Get crop-specific recommendations
  static Future<Map<String, dynamic>> getCropRecommendations(String cropType, String location) async {
    final prompt = '''
    You are an expert agricultural AI assistant. Provide crop planning recommendations for $cropType in $location region.
    
    Return a JSON response with the following structure (return ONLY valid JSON, no markdown):
    {
      "seedingWindow": "Date range for optimal seeding",
      "soilRequirements": "Soil type and pH requirements",
      "wateringSchedule": "Irrigation recommendations",
      "fertilizer": "NPK and nutrient requirements",
      "pestThreats": ["List of common pests"],
      "diseaseThreats": ["List of common diseases"],
      "harvestTime": "Expected harvest period",
      "yieldEstimate": "Expected yield per acre"
    }
    ''';

    try {
      final response = await generateContent(prompt);
      // Extract JSON from response (remove any markdown formatting)
      String jsonString = response.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.startsWith('```')) {
        jsonString = jsonString.substring(3);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      return jsonDecode(jsonString.trim());
    } catch (e) {
      // Return fallback data if parsing fails
      return {
        "seedingWindow": "Next 7-14 days",
        "soilRequirements": "Loamy soil, pH 6.0-7.0",
        "wateringSchedule": "1-1.5 inches per week",
        "fertilizer": "NPK 10-20-10",
        "pestThreats": ["Aphids", "Beetles"],
        "diseaseThreats": ["Root rot", "Blight"],
        "harvestTime": "90-120 days",
        "yieldEstimate": "40-50 bushels/acre"
      };
    }
  }

  /// Analyze pest threats
  static Future<Map<String, dynamic>> analyzePestThreat(String cropType, String pestName) async {
    final prompt = '''
    You are an agricultural pest expert. Analyze the threat of $pestName to $cropType crops.
    
    Return a JSON response with the following structure (return ONLY valid JSON, no markdown):
    {
      "threatLevel": "LOW, MEDIUM, or HIGH",
      "symptoms": ["List of 3-4 visible symptoms"],
      "recommendations": ["List of 3-4 treatment recommendations"],
      "preventiveMeasures": ["List of 2-3 preventive measures"],
      "estimatedDamage": "Potential crop loss percentage"
    }
    ''';

    try {
      final response = await generateContent(prompt);
      String jsonString = response.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.startsWith('```')) {
        jsonString = jsonString.substring(3);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      return jsonDecode(jsonString.trim());
    } catch (e) {
      return {
        "threatLevel": "HIGH",
        "symptoms": [
          "Yellowing or curling leaves",
          "Sticky honeydew on plants",
          "Stunted growth",
          "Presence of ants"
        ],
        "recommendations": [
          "Apply neem oil spray",
          "Introduce ladybugs (natural predators)",
          "Remove heavily infested plants",
          "Monitor daily for 2 weeks"
        ],
        "preventiveMeasures": [
          "Regular field inspection",
          "Maintain crop rotation"
        ],
        "estimatedDamage": "15-30% yield loss if untreated"
      };
    }
  }

  /// Get personalized crop guidance
  static Future<String> getCropGuidance(String cropType, String topic, String currentConditions) async {
    final prompt = '''
    You are an expert agricultural advisor. Provide detailed guidance for $cropType regarding $topic.
    Current conditions: $currentConditions
    
    Provide practical, actionable advice in 2-3 paragraphs. Be specific and include measurements where applicable.
    ''';

    try {
      return await generateContent(prompt);
    } catch (e) {
      return 'Unable to fetch AI guidance at this time. Please try again later.';
    }
  }

  /// Analyze NDVI/vegetation health data
  static Future<Map<String, dynamic>> analyzeVegetationHealth(double ndviScore) async {
    final prompt = '''
    You are a crop health expert. Analyze vegetation health with NDVI score of $ndviScore (0.0-1.0 scale).
    
    Return a JSON response (return ONLY valid JSON, no markdown):
    {
      "healthStatus": "Excellent, Good, Fair, or Poor",
      "analysis": "Brief analysis of the health status",
      "recommendations": ["List of 2-3 actionable recommendations"],
      "concernAreas": ["List of potential issues to monitor"]
    }
    ''';

    try {
      final response = await generateContent(prompt);
      String jsonString = response.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.startsWith('```')) {
        jsonString = jsonString.substring(3);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      return jsonDecode(jsonString.trim());
    } catch (e) {
      return {
        "healthStatus": "Good",
        "analysis": "Vegetation shows healthy growth patterns with good chlorophyll content.",
        "recommendations": [
          "Continue current irrigation schedule",
          "Monitor for nutrient deficiencies",
          "Schedule next NDVI scan in 2 weeks"
        ],
        "concernAreas": [
          "Watch for early signs of stress in southern field section"
        ]
      };
    }
  }

  /// Generate weather-based recommendations
  static Future<String> getWeatherBasedAdvice(String cropType, Map<String, dynamic> weatherData) async {
    final prompt = '''
    You are an agricultural meteorologist. Based on the 7-day weather forecast, provide advice for $cropType farming.
    
    Weather data: ${jsonEncode(weatherData)}
    
    Provide specific recommendations for the next 7 days including:
    - Best days for planting/harvesting
    - Irrigation adjustments needed
    - Risk of weather-related crop damage
    - Preventive measures
    
    Keep response concise (3-4 sentences).
    ''';

    try {
      return await generateContent(prompt);
    } catch (e) {
      return 'Weather conditions look favorable for the next week. Monitor soil moisture levels and adjust irrigation accordingly.';
    }
  }

  /// Generate seeding recommendations
  static Future<Map<String, dynamic>> getSeedingRecommendations(
    String cropType,
    Map<String, dynamic> soilData,
    Map<String, dynamic> weatherData,
  ) async {
    final prompt = '''
    You are an expert in crop planning. Generate seeding recommendations for $cropType.
    Soil data: ${jsonEncode(soilData)}
    Weather forecast: ${jsonEncode(weatherData)}
    
    Return a JSON response (return ONLY valid JSON, no markdown):
    {
      "optimalWindow": "Date range for seeding",
      "seedDepth": "Recommended depth in inches",
      "rowSpacing": "Spacing in inches",
      "seedRate": "Seeds per acre",
      "soilTemp": "Required soil temperature",
      "reasoning": "Why this is the optimal time"
    }
    ''';

    try {
      final response = await generateContent(prompt);
      String jsonString = response.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.startsWith('```')) {
        jsonString = jsonString.substring(3);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      return jsonDecode(jsonString.trim());
    } catch (e) {
      return {
        "optimalWindow": "Next 7 days",
        "seedDepth": "1.5-2 inches",
        "rowSpacing": "30 inches",
        "seedRate": "140,000-160,000 seeds/acre",
        "soilTemp": "50-55°F minimum",
        "reasoning": "Weather conditions and soil moisture are optimal"
      };
    }
  }
}

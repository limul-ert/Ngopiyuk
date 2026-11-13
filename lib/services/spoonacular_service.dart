import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class SpoonacularService {
  static Future<List<dynamic>> fetchCoffeeMenu() async {
    final url = Uri.parse('${ApiConfig.baseUrl}?query=coffee&apiKey=${ApiConfig.apiKey}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
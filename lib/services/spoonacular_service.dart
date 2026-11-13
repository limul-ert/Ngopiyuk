import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class SpoonacularService {
  // Ubah agar menerima parameter query kategori
  static Future<List<dynamic>> fetchMenuByCategory(String category) async {
    String searchQuery = 'coffee'; // Default
    
    // Sesuaikan kata kunci pencarian berdasarkan kategori aplikasi
    if (category == 'Makanan') {
      searchQuery = 'pasta'; // atau 'main course'
    } else if (category == 'Snack') {
      searchQuery = 'cookie'; // atau 'snack'
    }

    final url = Uri.parse('${ApiConfig.baseUrl}?query=$searchQuery&apiKey=${ApiConfig.apiKey}');

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
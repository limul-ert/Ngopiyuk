import 'dart:convert';
import 'package:http/http.dart' as http;

class OsmService {
  static const String _baseUrl = 'https://overpass-api.de/api/interpreter';

  // Fungsi untuk mengambil data kafe berdasarkan nama kota
  static Future<List<dynamic>> fetchCafes(String cityName) async {
    final query = '''
      [out:json];
      area[name="$cityName"]->.searchArea;
      node["amenity"="cafe"](area.searchArea);
      out body;
    ''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: query,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Mengembalikan daftar elemen kafe yang ditemukan
        return data['elements'] ?? [];
      } else {
        throw Exception('Gagal memuat data kafe: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cafes: $e');
      return [];
    }
  }
}
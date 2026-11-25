import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';

class SpoonacularService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      queryParameters: {'apiKey': ApiConfig.apiKey},
    ),
  );

  // Cache per kategori, supaya API tidak dipanggil ulang setiap layar
  // di-rebuild (menghemat kuota harian Spoonacular).
  static final Map<String, Future<List<dynamic>>> _cache = {};

  /// Mengambil daftar menu (field 'title' = nama, 'image' = gambar)
  /// sesuai kategori di aplikasi.
  static Future<List<dynamic>> fetchMenuByCategory(String category) {
    return _cache.putIfAbsent(category, () async {
      try {
        return await _fetch(category);
      } catch (_) {
        _cache.remove(category); // gagal -> boleh dicoba lagi
        rethrow;
      }
    });
  }

  static Future<List<dynamic>> _fetch(String category) async {
    if (ApiConfig.apiKey.isEmpty) {
      throw 'API key belum diisi. Jalankan dengan --dart-define=SPOONACULAR_KEY=...';
    }

    // Kata kunci pencarian berdasarkan kategori aplikasi
    String searchQuery = 'coffee';
    if (category == 'Makanan') {
      searchQuery = 'pasta';
    } else if (category == 'Snack') {
      searchQuery = 'cookie';
    }

    try {
      final res = await _dio.get(
        '/recipes/complexSearch',
        queryParameters: {'query': searchQuery, 'number': 10},
      );
      return (res.data['results'] as List?) ?? [];
    } on DioException catch (e) {
      debugPrint('Spoonacular error: $e');
      switch (e.response?.statusCode) {
        case 401:
          throw 'API key tidak valid.';
        case 402:
          throw 'Kuota API harian habis.';
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Koneksi timeout, coba lagi.';
      }
      throw 'Gagal memuat menu. Cek koneksi internet.';
    }
  }
}

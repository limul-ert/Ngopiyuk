import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/recipe.dart';

class RecipeService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      queryParameters: {'apiKey': ApiConfig.apiKey},
    ),
  );

  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final res = await _dio.get(
        '/recipes/complexSearch',
        queryParameters: {'query': query, 'number': 12},
      );
      final results = res.data['results'] as List;
      return results.map((e) => Recipe.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }

  Future<RecipeDetail> getRecipeDetail(int id) async {
    try {
      final res = await _dio.get('/recipes/$id/information');
      return RecipeDetail.fromJson(res.data);
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }

  String _errorMessage(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return 'API key tidak valid.';
      case 402:
        return 'Kuota API harian habis.';
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Koneksi timeout, coba lagi.';
    }
    return 'Gagal memuat data. Cek koneksi internet.';
  }
}
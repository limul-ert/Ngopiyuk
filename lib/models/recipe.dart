String _stripHtml(dynamic v) =>
    (v as String? ?? '').replaceAll(RegExp(r'<[^>]*>'), '').trim();

class Recipe {
  final int id;
  final String title;
  final String image;

  const Recipe({required this.id, required this.title, required this.image});

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        image: json['image'] as String? ?? '',
      );
}

class RecipeDetail {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final String summary;
  final String instructions;
  final List<String> ingredients;

  const RecipeDetail({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.summary,
    required this.instructions,
    required this.ingredients,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) => RecipeDetail(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        image: json['image'] as String? ?? '',
        readyInMinutes: json['readyInMinutes'] as int? ?? 0,
        servings: json['servings'] as int? ?? 0,
        summary: _stripHtml(json['summary']),
        instructions: _stripHtml(json['instructions']),
        ingredients: (json['extendedIngredients'] as List? ?? [])
            .map((e) => (e['original'] as String?) ?? '')
            .where((s) => s.isNotEmpty)
            .toList(),
      );
}
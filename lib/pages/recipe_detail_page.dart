import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/cafe_image.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0F0F0F);

  late final Future<RecipeDetail> _future =
      RecipeService().getRecipeDetail(widget.recipe.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.recipe.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: FutureBuilder<RecipeDetail>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          }
          if (snap.hasError) {
            return Center(
              child: Text('${snap.error}',
                  style: const TextStyle(color: Colors.grey)),
            );
          }
          final d = snap.data!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              CafeImage(
                source: d.image,
                height: 240,
                width: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(height: 16),
              Text(d.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.timer_outlined, color: primaryColor, size: 18),
                const SizedBox(width: 4),
                Text('${d.readyInMinutes} menit',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                const Icon(Icons.people_outline, color: primaryColor, size: 18),
                const SizedBox(width: 4),
                Text('${d.servings} porsi',
                    style: const TextStyle(color: Colors.grey)),
              ]),
              _section('Ringkasan', d.summary),
              _section('Bahan', d.ingredients.map((e) => '• $e').join('\n')),
              _section('Cara Membuat', d.instructions),
            ],
          );
        },
      ),
    );
  }

  Widget _section(String title, String body) {
    if (body.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.6)),
        ],
      ),
    );
  }
}
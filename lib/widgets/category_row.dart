import 'package:flutter/material.dart';

class CategoryRow extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryRow({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final name = cat['name'] as String;
          final isSelected = name == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFC8956D)
                    : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFC8956D)
                      : Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey,
                    fontSize: 13,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
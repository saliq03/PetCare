import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories = const [
    'All',
    'Vet',
    'Grooming',
    'Boarding',
    'Training',
    'Pet Store',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == categories.length - 1 ? 0 : 8,
            ),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                onCategorySelected(category);
              },
              backgroundColor: Colors.grey[100],
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
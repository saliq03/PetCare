import 'package:flutter/material.dart';

class PetTypeSelector extends StatelessWidget {
  final String selectedPetType;
  final Function(String) onPetTypeSelected;

  const PetTypeSelector({
    super.key,
    required this.selectedPetType,
    required this.onPetTypeSelected,
  });

  final List<String> petTypes = const ['Dog', 'Cat', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pet Type',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: petTypes.map((petType) {
            final isSelected = petType == selectedPetType;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: petType == petTypes.last ? 0 : 8,
                ),
                child: ChoiceChip(
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getPetIcon(petType),
                        size: 16,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(petType),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) => onPetTypeSelected(petType),
                  backgroundColor: Colors.grey[100],
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getPetIcon(String petType) {
    switch (petType) {
      case 'Dog':
        return Icons.pets;
      case 'Cat':
        return Icons.cruelty_free;
      case 'Other':
        return Icons.emoji_nature;
      default:
        return Icons.pets;
    }
  }
}
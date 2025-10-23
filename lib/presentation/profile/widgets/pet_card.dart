import 'package:flutter/material.dart';
import 'package:petcare/data/models/user_model.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PetCard({
    super.key,
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Pet Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getPetColor(pet.type).withOpacity(0.1),
              ),
              child: pet.imageUrl != null
                  ? ClipOval(
                child: Image.network(
                  pet.imageUrl!,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                _getPetIcon(pet.type),
                size: 30,
                color: _getPetColor(pet.type),
              ),
            ),
            const SizedBox(width: 16),

            // Pet Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pet.displayInfo,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (pet.medicalNotes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      pet.medicalNotes.first,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange[600],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Actions
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[600]),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit Pet'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Pet', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPetIcon(String type) {
    switch (type.toLowerCase()) {
      case 'dog':
        return Icons.pets;
      case 'cat':
        return Icons.cruelty_free;
      default:
        return Icons.emoji_nature;
    }
  }

  Color _getPetColor(String type) {
    switch (type.toLowerCase()) {
      case 'dog':
        return Colors.amber;
      case 'cat':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }
}
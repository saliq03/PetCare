class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profileImage;
  final DateTime joinedDate;
  final List<Pet> pets;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.profileImage,
    required this.joinedDate,
    this.pets = const [],
  });

  String get formattedJoinedDate {
    return 'Joined ${_formatDate(joinedDate)}';
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class Pet {
  final String id;
  final String name;
  final String type;
  final String breed;
  final DateTime birthDate;
  final double weight;
  final String? imageUrl;
  final List<String> medicalNotes;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.birthDate,
    required this.weight,
    this.imageUrl,
    this.medicalNotes = const [],
  });

  String get age {
    final now = DateTime.now();
    final ageInMonths = (now.difference(birthDate).inDays / 30).floor();

    if (ageInMonths < 12) {
      return '$ageInMonths months';
    } else {
      final years = (ageInMonths / 12).floor();
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
  }

  String get displayInfo {
    return '$breed • $age • ${weight}kg';
  }
}
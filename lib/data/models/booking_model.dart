class Booking {
  final String id;
  final String facilityId;
  final String facilityName;
  final String petType;
  final DateTime date;
  final String timeSlot;
  final double price;
  final String status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.petType,
    required this.date,
    required this.timeSlot,
    required this.price,
    this.status = 'Confirmed',
    required this.createdAt,
  });

  String get bookingId => 'BK${id.padLeft(6, '0')}';

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get displayDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDay = DateTime(date.year, date.month, date.day);

    if (bookingDay == today) {
      return 'Today';
    } else if (bookingDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return formattedDate;
    }
  }
}
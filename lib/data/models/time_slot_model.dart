class TimeSlot {
  final String time;
  final bool available;

  const TimeSlot({
    required this.time,
    required this.available,
  });

  static List<TimeSlot> get morningSlots => const [
    TimeSlot(time: '09:00 AM', available: true),
    TimeSlot(time: '09:30 AM', available: true),
    TimeSlot(time: '10:00 AM', available: false),
    TimeSlot(time: '10:30 AM', available: true),
    TimeSlot(time: '11:00 AM', available: true),
    TimeSlot(time: '11:30 AM', available: true),
  ];

  static List<TimeSlot> get afternoonSlots => const [
    TimeSlot(time: '12:00 PM', available: true),
    TimeSlot(time: '12:30 PM', available: true),
    TimeSlot(time: '01:00 PM', available: false),
    TimeSlot(time: '01:30 PM', available: true),
    TimeSlot(time: '02:00 PM', available: true),
    TimeSlot(time: '02:30 PM', available: true),
  ];

  static List<TimeSlot> get eveningSlots => const [
    TimeSlot(time: '03:00 PM', available: true),
    TimeSlot(time: '03:30 PM', available: true),
    TimeSlot(time: '04:00 PM', available: true),
    TimeSlot(time: '04:30 PM', available: false),
    TimeSlot(time: '05:00 PM', available: true),
    TimeSlot(time: '05:30 PM', available: true),
  ];
}
import 'package:flutter/material.dart';
import '../models/booking_model.dart';

class MyBookingsRepository {
  // Private static list to hold dummy bookings
  static final List<Booking> _bookings = [];

  // Initialize with some sample data
  static void initializeDummyData() {
    final now = DateTime.now();
    _bookings.addAll([
      Booking(
        id: '1',
        facilityId: '1',
        facilityName: 'Paws & Claws Vet Clinic',
        petType: 'Dog',
        date: now.add(const Duration(days: 1)),
        timeSlot: '10:00 AM',
        price: 500,
        status: 'Confirmed',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      Booking(
        id: '2',
        facilityId: '2',
        facilityName: 'Grooming Paradise',
        petType: 'Cat',
        date: now.add(const Duration(days: 3)),
        timeSlot: '02:30 PM',
        price: 800,
        status: 'Confirmed',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Booking(
        id: '3',
        facilityId: '4',
        facilityName: 'Pet Training Academy',
        petType: 'Dog',
        date: now.subtract(const Duration(days: 2)),
        timeSlot: '11:00 AM',
        price: 1500,
        status: 'Completed',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ]);
  }

  /// Get all bookings
  static List<Booking> getAllBookings() {
    return List.unmodifiable(_bookings);
  }

  /// Get bookings by status (e.g., "Confirmed" or "Completed")
  static List<Booking> getBookingsByStatus(String status) {
    return _bookings.where((b) => b.status == status).toList();
  }

  /// Add a new booking
  static void addBooking(Booking booking) {
    _bookings.add(booking);
  }

  /// Get a booking by ID
  static Booking? getBookingById(String id) {
    return _bookings.firstWhere((b) => b.id == id, orElse: () => null as Booking);
  }

  /// Remove a booking
  static void removeBooking(String id) {
    _bookings.removeWhere((b) => b.id == id);
  }

  /// Clear all dummy data (optional)
  static void clear() {
    _bookings.clear();
  }
}

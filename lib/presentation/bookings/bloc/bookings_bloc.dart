import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/booking_model.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  BookingsBloc() : super(BookingsInitial()) {
    on<LoadBookingsEvent>(_onLoadBookings);
    on<CancelBookingEvent>(_onCancelBooking);
    on<RefreshBookingsEvent>(_onRefreshBookings);
  }

  FutureOr<void> _onLoadBookings(LoadBookingsEvent event, Emitter<BookingsState> emit) async {
    emit(BookingsLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final bookings = _getDummyBookings();

      if (bookings.isEmpty) {
        emit(BookingsEmpty());
      } else {
        final now = DateTime.now();
        final upcomingBookings = bookings.where((booking) => booking.date.isAfter(now)).toList();
        final pastBookings = bookings.where((booking) => booking.date.isBefore(now)).toList();

        emit(BookingsLoaded(
          bookings: bookings,
          upcomingBookings: upcomingBookings,
          pastBookings: pastBookings,
        ));
      }
    } catch (e) {
      emit(const BookingsError('Failed to load bookings'));
    }
  }

  FutureOr<void> _onCancelBooking(CancelBookingEvent event, Emitter<BookingsState> emit) async {
    if (state is BookingsLoaded) {
      emit(BookingsLoading());

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      try {
        // In a real app, this would call an API to cancel the booking
        // For now, we'll just filter it out from our dummy data
        final currentState = state as BookingsLoaded;
        final updatedBookings = currentState.bookings.where((booking) => booking.id != event.bookingId).toList();

        if (updatedBookings.isEmpty) {
          emit(BookingsEmpty());
        } else {
          final now = DateTime.now();
          final upcomingBookings = updatedBookings.where((booking) => booking.date.isAfter(now)).toList();
          final pastBookings = updatedBookings.where((booking) => booking.date.isBefore(now)).toList();

          emit(BookingsLoaded(
            bookings: updatedBookings,
            upcomingBookings: upcomingBookings,
            pastBookings: pastBookings,
          ));

          // Also emit cancellation success
          emit(BookingCancelled(event.bookingId));
        }
      } catch (e) {
        emit(const BookingsError('Failed to cancel booking'));
      }
    }
  }

  FutureOr<void> _onRefreshBookings(RefreshBookingsEvent event, Emitter<BookingsState> emit) async {
    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 500));
    add(LoadBookingsEvent());
  }

  List<Booking> _getDummyBookings() {
    final now = DateTime.now();
    return [
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
      Booking(
        id: '4',
        facilityId: '5',
        facilityName: 'Pet Store Central',
        petType: 'Other',
        date: now.subtract(const Duration(days: 7)),
        timeSlot: '04:00 PM',
        price: 200,
        status: 'Completed',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      Booking(
        id: '5',
        facilityId: '1',
        facilityName: 'Paws & Claws Vet Clinic',
        petType: 'Dog',
        date: now.add(const Duration(days: 5)),
        timeSlot: '03:00 PM',
        price: 500,
        status: 'Confirmed',
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
    ];
  }
}
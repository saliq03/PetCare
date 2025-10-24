import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petcare/core/config/constants/status.dart';

import '../../../data/models/booking_model.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  BookingsBloc() : super(BookingsState()) {
    on<LoadBookingsEvent>(_onLoadBookings);
    on<RefreshBookingsEvent>(_onRefreshBookings);
  }

  FutureOr<void> _onLoadBookings(LoadBookingsEvent event, Emitter<BookingsState> emit) async {
    emit(state.copyWith(status: Status.loading));

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      List<Booking> bookings = _getDummyBookings();

      if (bookings.isNotEmpty) {
        final now = DateTime.now();
        final List<Booking> upcomingBookings =bookings.where((booking) => booking.date.isAfter(now)).toList();
        final pastBookings = bookings.where((booking) => booking.date.isBefore(now)).toList();

        emit(state.copyWith(
          bookings: bookings,
          upcomingBookings: upcomingBookings,
          pastBookings: pastBookings,
          status: Status.completed
        ));
      }
      emit(state.copyWith(status: Status.completed));


    } catch (e) {
      emit(state.copyWith(status: Status.error));
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
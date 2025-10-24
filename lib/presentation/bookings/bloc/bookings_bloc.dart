import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petcare/core/config/constants/status.dart';
import 'package:petcare/data/repository/my_bookings.dart';

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
      List<Booking> bookings=[];
       List<Booking> upcomingBookings=[];
       List<Booking> pastBookings=[];
      bookings = MyBookingsRepository.getAllBookings();

      if (bookings.isNotEmpty) {
        final now = DateTime.now();
        upcomingBookings =bookings.where((booking) => booking.date.isAfter(now)).toList();
         pastBookings = bookings.where((booking) => booking.date.isBefore(now)).toList();

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

}
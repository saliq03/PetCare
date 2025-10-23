part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object> get props => [];
}

class LoadBookingsEvent extends BookingsEvent {}

class CancelBookingEvent extends BookingsEvent {
  final String bookingId;

  const CancelBookingEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class RefreshBookingsEvent extends BookingsEvent {}
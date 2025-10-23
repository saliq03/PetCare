part of 'bookings_bloc.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<Booking> bookings;
  final List<Booking> upcomingBookings;
  final List<Booking> pastBookings;

  const BookingsLoaded({
    required this.bookings,
    required this.upcomingBookings,
    required this.pastBookings,
  });

  @override
  List<Object> get props => [bookings, upcomingBookings, pastBookings];
}

class BookingsEmpty extends BookingsState {}

class BookingCancelled extends BookingsState {
  final String bookingId;

  const BookingCancelled(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class BookingsError extends BookingsState {
  final String message;

  const BookingsError(this.message);

  @override
  List<Object> get props => [message];
}
part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object> get props => [];
}

class LoadBookingsEvent extends BookingsEvent {}


class RefreshBookingsEvent extends BookingsEvent {}
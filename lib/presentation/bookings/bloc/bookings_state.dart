part of 'bookings_bloc.dart';

 class BookingsState extends Equatable {
  final List<Booking> bookings;
  final List<Booking> upcomingBookings;
  final List<Booking> pastBookings;
  final Status status;

  const BookingsState({
    this.bookings=const [],
    this.upcomingBookings= const [],
     this.pastBookings=const[],
    this.status=Status.initial
  });

  BookingsState copyWith({
    List<Booking>? bookings,
     List<Booking>? upcomingBookings,
    List<Booking>? pastBookings,
    Status? status}){
    return BookingsState(
      bookings: bookings ??this.bookings,
      upcomingBookings: upcomingBookings ?? this.upcomingBookings,
      pastBookings: pastBookings ?? this.pastBookings,
      status: status ?? this.status
    );
  }
  @override
  List<Object> get props => [bookings, upcomingBookings, pastBookings,status];
}
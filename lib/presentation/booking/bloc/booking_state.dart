part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class FacilityDetailsLoaded extends BookingState {
  final Facility facility;
  final String selectedPetType;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final bool isBookingValid;

  const FacilityDetailsLoaded({
    required this.facility,
    this.selectedPetType = 'Dog',
    required this.selectedDate,
    this.selectedTimeSlot = '',
    this.isBookingValid = false,
  });

  @override
  List<Object> get props => [
    facility,
    selectedPetType,
    selectedDate,
    selectedTimeSlot,
    isBookingValid,
  ];

  FacilityDetailsLoaded copyWith({
    Facility? facility,
    String? selectedPetType,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    bool? isBookingValid,
  }) {
    return FacilityDetailsLoaded(
      facility: facility ?? this.facility,
      selectedPetType: selectedPetType ?? this.selectedPetType,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      isBookingValid: isBookingValid ?? this.isBookingValid,
    );
  }
}

class BookingConfirmed extends BookingState {
  final Booking booking;

  const BookingConfirmed(this.booking);

  @override
  List<Object> get props => [booking];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object> get props => [message];
}
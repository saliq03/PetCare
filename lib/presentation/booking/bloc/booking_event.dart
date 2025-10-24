part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class LoadFacilityDetailsEvent extends BookingEvent {
  final String facilityId;

  const LoadFacilityDetailsEvent(this.facilityId);

  @override
  List<Object> get props => [facilityId];
}

class SelectPetTypeEvent extends BookingEvent {
  final String petType;

  const SelectPetTypeEvent(this.petType);

  @override
  List<Object> get props => [petType];
}

class SelectDateEvent extends BookingEvent {
  final DateTime date;

  const SelectDateEvent(this.date);

  @override
  List<Object> get props => [date];
}

class SelectTimeSlotEvent extends BookingEvent {
  final String timeSlot;

  const SelectTimeSlotEvent(this.timeSlot);

  @override
  List<Object> get props => [timeSlot];
}

class ConfirmBookingEvent extends BookingEvent {
  final String facilityId;
  final String facilityName;
  final String petType;
  final DateTime date;
  final String timeSlot;
  final double price;
  final BuildContext context;

  const ConfirmBookingEvent({
    required this.facilityId,
    required this.facilityName,
    required this.petType,
    required this.date,
    required this.timeSlot,
    required this.price,
    required this.context
  });

  @override
  List<Object> get props => [facilityId, facilityName, petType, date, timeSlot, price,context];
}
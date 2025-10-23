import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/booking_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repository/dummy_data.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<LoadFacilityDetailsEvent>(_onLoadFacilityDetails);
    on<SelectPetTypeEvent>(_onSelectPetType);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<ConfirmBookingEvent>(_onConfirmBooking);
  }

  FutureOr<void> _onLoadFacilityDetails(LoadFacilityDetailsEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final facility = DummyData.facilities.firstWhere(
            (facility) => facility.id == event.facilityId,
      );

      emit(FacilityDetailsLoaded(
        facility: facility,
        selectedDate: DateTime.now().add(const Duration(days: 1)),
      ));
    } catch (e) {
      emit(const BookingError('Facility not found'));
    }
  }

  FutureOr<void> _onSelectPetType(SelectPetTypeEvent event, Emitter<BookingState> emit) {
    if (state is FacilityDetailsLoaded) {
      final currentState = state as FacilityDetailsLoaded;
      final isBookingValid = _validateBooking(
        event.petType,
        currentState.selectedDate,
        currentState.selectedTimeSlot,
      );

      emit(currentState.copyWith(
        selectedPetType: event.petType,
        isBookingValid: isBookingValid,
      ));
    }
  }

  FutureOr<void> _onSelectDate(SelectDateEvent event, Emitter<BookingState> emit) {
    if (state is FacilityDetailsLoaded) {
      final currentState = state as FacilityDetailsLoaded;
      final isBookingValid = _validateBooking(
        currentState.selectedPetType,
        event.date,
        currentState.selectedTimeSlot,
      );

      emit(currentState.copyWith(
        selectedDate: event.date,
        isBookingValid: isBookingValid,
      ));
    }
  }

  FutureOr<void> _onSelectTimeSlot(SelectTimeSlotEvent event, Emitter<BookingState> emit) {
    if (state is FacilityDetailsLoaded) {
      final currentState = state as FacilityDetailsLoaded;
      final isBookingValid = _validateBooking(
        currentState.selectedPetType,
        currentState.selectedDate,
        event.timeSlot,
      );

      emit(currentState.copyWith(
        selectedTimeSlot: event.timeSlot,
        isBookingValid: isBookingValid,
      ));
    }
  }

  FutureOr<void> _onConfirmBooking(ConfirmBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        facilityId: event.facilityId,
        facilityName: event.facilityName,
        petType: event.petType,
        date: event.date,
        timeSlot: event.timeSlot,
        price: event.price,
        createdAt: DateTime.now(),
      );

      // Save to local storage (in real app, this would be to backend)
      _saveBookingLocally(booking);

      emit(BookingConfirmed(booking));
    } catch (e) {
      emit(const BookingError('Failed to confirm booking'));
    }
  }

  bool _validateBooking(String petType, DateTime date, String timeSlot) {
    return petType.isNotEmpty && timeSlot.isNotEmpty;
  }

  void _saveBookingLocally(Booking booking) {
    // In a real app, this would save to shared preferences or local database
    // For now, we'll just keep it in memory and the bookings page will use dummy data
    print('Booking saved: ${booking.bookingId}');
  }
}
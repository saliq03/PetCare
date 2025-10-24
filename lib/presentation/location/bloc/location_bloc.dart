import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petcare/common/helpers/UserPrefrences.dart';
import 'package:petcare/dependency_injection.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {


  LocationBloc() : super(LocationInitial()) {
    on<LoadLocationsEvent>(_onLoadLocations);
    on<SelectLocationEvent>(_onSelectLocation);
    on<UseCurrentLocationEvent>(_onUseCurrentLocation);
  }

  FutureOr<void> _onLoadLocations(LoadLocationsEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    // Get saved location or use default
    final savedLocation =await sL<UserPreferences>().getSelectedLocation()?? 'Hyderabad';

    final isCurrentLocation =await sL<UserPreferences>().getIsCurrentLocation()?? false;

    emit(LocationLoaded(
      locations: const ['Hyderabad', 'Bengaluru', 'Pune'],
      selectedLocation: savedLocation,
      isCurrentLocation: isCurrentLocation,
    ));
  }

  FutureOr<void> _onSelectLocation(SelectLocationEvent event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;

      // Save to shared preferences
      await sL<UserPreferences>().setSelectedLocation(event.location);
      await sL<UserPreferences>().setIsCurrentLocation(false);

      emit(LocationLoaded(
        locations: currentState.locations,
        selectedLocation: event.location,
        isCurrentLocation: false,
      ));
    }
  }

  FutureOr<void> _onUseCurrentLocation(UseCurrentLocationEvent event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      final currentState = state as LocationLoaded;

      // Mock current location
      const mockCurrentLocation = 'Current Location';
      await sL<UserPreferences>().setSelectedLocation(mockCurrentLocation);
      await sL<UserPreferences>().setIsCurrentLocation(true);


      emit(LocationLoaded(
        locations: currentState.locations,
        selectedLocation: mockCurrentLocation,
        isCurrentLocation: true,
      ));
    }
  }
}
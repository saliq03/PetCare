import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  static const String _selectedLocationKey = 'selectedLocation';
  static const String _isCurrentLocationKey = 'isCurrentLocation';

  LocationBloc() : super(LocationInitial()) {
    on<LoadLocationsEvent>(_onLoadLocations);
    on<SelectLocationEvent>(_onSelectLocation);
    on<UseCurrentLocationEvent>(_onUseCurrentLocation);
  }

  FutureOr<void> _onLoadLocations(LoadLocationsEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    // Get saved location or use default
    final savedLocation = 'Hyderabad';
        // sharedPreferences.getString(_selectedLocationKey) ?? 'Hyderabad';

    final isCurrentLocation = false;
        // sharedPreferences.getBool(_isCurrentLocationKey) ?? false;

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
      // await sharedPreferences.setString(_selectedLocationKey, event.location);
      // await sharedPreferences.setBool(_isCurrentLocationKey, false);

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

      // await sharedPreferences.setString(_selectedLocationKey, mockCurrentLocation);
      // await sharedPreferences.setBool(_isCurrentLocationKey, true);

      emit(LocationLoaded(
        locations: currentState.locations,
        selectedLocation: mockCurrentLocation,
        isCurrentLocation: true,
      ));
    }
  }
}
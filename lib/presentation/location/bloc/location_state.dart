part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<String> locations;
  final String selectedLocation;
  final bool isCurrentLocation;

  const LocationLoaded({
    required this.locations,
    required this.selectedLocation,
    this.isCurrentLocation = false,
  });

  @override
  List<Object> get props => [locations, selectedLocation, isCurrentLocation];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object> get props => [message];
}
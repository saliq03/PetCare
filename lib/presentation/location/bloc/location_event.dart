part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LoadLocationsEvent extends LocationEvent {}

class SelectLocationEvent extends LocationEvent {
  final String location;

  const SelectLocationEvent(this.location);

  @override
  List<Object> get props => [location];
}

class UseCurrentLocationEvent extends LocationEvent {}
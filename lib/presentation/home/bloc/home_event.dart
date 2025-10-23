part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadFacilitiesEvent extends HomeEvent {
  final String location;

  const LoadFacilitiesEvent(this.location);

  @override
  List<Object> get props => [location];
}

class SearchFacilitiesEvent extends HomeEvent {
  final String query;

  const SearchFacilitiesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByCategoryEvent extends HomeEvent {
  final String category;

  const FilterByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class ClearFiltersEvent extends HomeEvent {}
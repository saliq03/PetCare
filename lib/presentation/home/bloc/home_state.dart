part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Facility> facilities;
  final List<Facility> filteredFacilities;
  final String searchQuery;
  final String selectedCategory;
  final String location;

  const HomeLoaded({
    required this.facilities,
    required this.filteredFacilities,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    required this.location,
  });

  @override
  List<Object> get props => [
    facilities,
    filteredFacilities,
    searchQuery,
    selectedCategory,
    location,
  ];

  HomeLoaded copyWith({
    List<Facility>? facilities,
    List<Facility>? filteredFacilities,
    String? searchQuery,
    String? selectedCategory,
    String? location,
  }) {
    return HomeLoaded(
      facilities: facilities ?? this.facilities,
      filteredFacilities: filteredFacilities ?? this.filteredFacilities,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      location: location ?? this.location,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
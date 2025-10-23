import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/repository/dummy_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadFacilitiesEvent>(_onLoadFacilities);
    on<SearchFacilitiesEvent>(_onSearchFacilities);
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  FutureOr<void> _onLoadFacilities(LoadFacilitiesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Filter facilities by location
      final facilities = DummyData.facilities
          .where((facility) => facility.location == event.location)
          .toList();

      emit(HomeLoaded(
        facilities: facilities,
        filteredFacilities: facilities,
        location: event.location,
      ));
    } catch (e) {
      emit(HomeError('Failed to load facilities'));
    }
  }

  FutureOr<void> _onSearchFacilities(SearchFacilitiesEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      List<Facility> filtered = currentState.facilities;

      // Apply search filter
      if (event.query.isNotEmpty) {
        filtered = filtered.where((facility) {
          return facility.name.toLowerCase().contains(event.query.toLowerCase()) ||
              facility.category.toLowerCase().contains(event.query.toLowerCase()) ||
              facility.description.toLowerCase().contains(event.query.toLowerCase());
        }).toList();
      }

      // Apply category filter if any
      if (currentState.selectedCategory != 'All') {
        filtered = filtered.where((facility) => facility.category == currentState.selectedCategory).toList();
      }

      emit(currentState.copyWith(
        filteredFacilities: filtered,
        searchQuery: event.query,
      ));
    }
  }

  FutureOr<void> _onFilterByCategory(FilterByCategoryEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      List<Facility> filtered = currentState.facilities;

      // Apply category filter
      if (event.category != 'All') {
        filtered = filtered.where((facility) => facility.category == event.category).toList();
      }

      // Apply search filter if any
      if (currentState.searchQuery.isNotEmpty) {
        filtered = filtered.where((facility) {
          return facility.name.toLowerCase().contains(currentState.searchQuery.toLowerCase()) ||
              facility.category.toLowerCase().contains(currentState.searchQuery.toLowerCase()) ||
              facility.description.toLowerCase().contains(currentState.searchQuery.toLowerCase());
        }).toList();
      }

      emit(currentState.copyWith(
        filteredFacilities: filtered,
        selectedCategory: event.category,
      ));
    }
  }

  FutureOr<void> _onClearFilters(ClearFiltersEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      emit(currentState.copyWith(
        filteredFacilities: currentState.facilities,
        searchQuery: '',
        selectedCategory: 'All',
      ));
    }
  }
}
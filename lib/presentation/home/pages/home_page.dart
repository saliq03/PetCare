import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/facility_model.dart';
import '../../booking/bloc/booking_bloc.dart';
import '../../booking/pages/facility_details_page.dart';
import '../../location/bloc/location_bloc.dart';
import '../../location/widgets/location_chip.dart';
import '../../location/widgets/location_modal_sheet.dart';
import '../bloc/home_bloc.dart';
import '../widgets/category_chips.dart';
import '../widgets/facility_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late HomeBloc _homeBloc;
  late LocationBloc _locationBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
    _locationBloc=LocationBloc();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _homeBloc.close();

    super.dispose();
  }

  void _showLocationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const LocationModalSheet();
      },
    );
  }

  void _loadFacilities(String location) {
    _homeBloc.add(LoadFacilitiesEvent(location));
  }

  void _onSearchChanged(String query) {
    _homeBloc.add(SearchFacilitiesEvent(query));
  }

  void _onCategorySelected(String category) {
    _homeBloc.add(FilterByCategoryEvent(category));
  }

  void _onFacilityTap(Facility facility) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => BookingBloc(),
          child: FacilityDetailsPage(facilityId: facility.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeBloc),
        BlocProvider.value(value: _locationBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'PetCare',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 20),
              ),
              onPressed: () {
                // Navigate to profile
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocListener<LocationBloc, LocationState>(
          listener: (context, locationState) {
            if (locationState is LocationLoaded) {
              _loadFacilities(locationState.selectedLocation);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message
                Text(
                  'Find the best care for your pet',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),

                // Location Selector
                Row(
                  children: [
                    Text(
                      'Location:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    LocationChip(onTap: _showLocationModal),
                  ],
                ),
                const SizedBox(height: 24),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search facilities or services...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear, size: 20, color: Colors.grey[500]),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Category Filters
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return CategoryChips(
                      selectedCategory: state is HomeLoaded ? state.selectedCategory : 'All',
                      onCategorySelected: _onCategorySelected,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Facilities Grid
                BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, locationState) {
                    return BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state is HomeError) {
                          return Center(
                            child: Column(
                              children: [
                                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  state.message,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    if (locationState is LocationLoaded) {
                                      _loadFacilities(locationState.selectedLocation);
                                    }
                                  },
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is HomeLoaded) {
                          if (state.filteredFacilities.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No facilities found',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    state.searchQuery.isNotEmpty
                                        ? 'Try adjusting your search or filters'
                                        : 'No facilities available in ${state.location}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (state.searchQuery.isNotEmpty || state.selectedCategory != 'All')
                                    const SizedBox(height: 16),
                                  if (state.searchQuery.isNotEmpty || state.selectedCategory != 'All')
                                    ElevatedButton(
                                      onPressed: () {
                                        _homeBloc.add(ClearFiltersEvent());
                                        _searchController.clear();
                                      },
                                      child: const Text('Clear Filters'),
                                    ),
                                ],
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.filteredFacilities.length} facilities in ${state.location}',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: state.filteredFacilities.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final facility = state.filteredFacilities[index];
                                  return FacilityCard(
                                    facility: facility,
                                    onTap: () => _onFacilityTap(facility),
                                  );
                                },
                              ),
                            ],
                          );
                        }

                        // Initial state - show placeholder
                        return Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.pets,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Select a location to see facilities',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
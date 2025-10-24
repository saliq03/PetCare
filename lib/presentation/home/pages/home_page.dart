import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/common/widgets/ui_helper.dart';

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
    _locationBloc = LocationBloc()..add(LoadLocationsEvent());
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
        return BlocProvider.value(
          value: _locationBloc, // reuse the existing bloc instance
          child: const LocationModalSheet(),
        );
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
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
              color: Color(0xFF3F09AB),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF3F09AB).withOpacity(.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 20,color: Colors.white,),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find the best care for your pet',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16.h),

                // Location Selector
                Row(
                  children: [
                    Text(
                      'Location:',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
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
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Color(0xffF1F1F1),
                  borderRadius: BorderRadius.circular(12.r),
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
                    Icon(Icons.search, color: Colors.grey[500], size: 25),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffF1F1F1),
                          hintText: 'Search facilities or services...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 10.h),

                // Category Filters
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return CategoryChips(
                      selectedCategory: state is HomeLoaded ? state.selectedCategory : 'All',
                      onCategorySelected: _onCategorySelected,
                    );
                  },
                ),
               SizedBox(height: 10.h),

                // Facilities Grid
                BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, locationState) {
                    return BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          return loadingWidget();
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
                            return Center(
                              child: Container(
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
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.filteredFacilities.length} facilities in ${state.location}',
                                style: GoogleFonts.inter(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                               SizedBox(height: 16.h),
                              GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.65,
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

  Widget loadingWidget(){
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return UiHelper.shimmerWidget(width: 100, height: 100,borderRadius: 12.sp);
      },
    );
  }
}
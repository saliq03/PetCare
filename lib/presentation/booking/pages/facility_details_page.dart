import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/booking_model.dart';
import '../../main/pages/main_page.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/date_selector.dart';
import '../widgets/pet_type_selector.dart';
import '../widgets/time_slot_selector.dart';

class FacilityDetailsPage extends StatefulWidget {
  final String facilityId;

  const FacilityDetailsPage({super.key, required this.facilityId});

  @override
  State<FacilityDetailsPage> createState() => _FacilityDetailsPageState();
}

class _FacilityDetailsPageState extends State<FacilityDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadFacilityDetailsEvent(widget.facilityId));
  }

  void _showBookingSuccessDialog(Booking booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Booking Confirmed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment booked successfully for ${booking.facilityName} on ${booking.displayDate} at ${booking.timeSlot}.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Booking ID: ${booking.bookingId}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // In facility_details_page.dart, update the success dialog actions
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
             },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Facility Details',style: GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      ),),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share facility details
            },
          ),
        ],
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingConfirmed) {
            _showBookingSuccessDialog(state.booking);
          }
        },
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      context.read<BookingBloc>().add(LoadFacilityDetailsEvent(widget.facilityId));
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is FacilityDetailsLoaded) {
            return _buildFacilityDetails(context, state);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildFacilityDetails(BuildContext context, FacilityDetailsLoaded state) {
    final facility = state.facility;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Facility Image
          Hero(
            tag: facility.imageUrl,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: facility.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Facility Name and Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  facility.name,
                  style: GoogleFonts.inter(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                     SizedBox(width: 4.w),
                    Text(
                      facility.ratingText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
         SizedBox(height: 8.h),

          // Category and Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(facility.category),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  facility.category,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
               SizedBox(width: 8.w),
              Container(
                padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: facility.isOpen ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  facility.isOpen ? 'Open Now' : 'Closed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price and Distance
          Row(
            children: [
              Text(
                facility.priceRange,
                style: GoogleFonts.inter(
                  color: Color(0xFF3F09AB),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 16.h),
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Text(
                facility.distanceText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Description
          Text(
            'Description',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            facility.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),

          // Services
          Text(
            'Services',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: facility.services.map((service) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              );
            }).toList(),
          ),
           SizedBox(height: 24.h),

          // Contact Info
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                 SizedBox(height: 12.h),
                _buildContactItem(Icons.location_on, facility.address),
                SizedBox(height: 8.h),
                _buildContactItem(Icons.phone, facility.phone),
                SizedBox(height: 8.h),
                _buildContactItem(Icons.access_time, 'Hours: ${facility.hours}'),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          // Booking Section
          Text(
            'Book an Appointment',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 24.h),

          // Pet Type Selector
          PetTypeSelector(
            selectedPetType: state.selectedPetType,
            onPetTypeSelected: (petType) {
              context.read<BookingBloc>().add(SelectPetTypeEvent(petType));
            },
          ),
         SizedBox(height: 24.h),

          // Date Selector
          DateSelector(
            selectedDate: state.selectedDate,
            onDateSelected: (date) {
              context.read<BookingBloc>().add(SelectDateEvent(date));
            },
          ),
         SizedBox(height: 24.h),

          // Time Slot Selector
          TimeSlotSelector(
            selectedTimeSlot: state.selectedTimeSlot,
            onTimeSlotSelected: (timeSlot) {
              context.read<BookingBloc>().add(SelectTimeSlotEvent(timeSlot));
            },
          ),
          SizedBox(height: 32.h),

          // Book Now Button
          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              final isBookingValid = state is FacilityDetailsLoaded && state.isBookingValid;
              final isLoading = state is BookingLoading;

              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isBookingValid && !isLoading
                      ? () {
                    context.read<BookingBloc>().add(
                      ConfirmBookingEvent(
                        facilityId: widget.facilityId,
                        facilityName: facility.name,
                        petType: (state).selectedPetType,
                        date: state.selectedDate,
                        timeSlot: state.selectedTimeSlot,
                        price: facility.price,
                        context: context
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ?  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Book Appointment - ${facility.priceRange}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
           SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Vet':
        return Colors.red;
      case 'Grooming':
        return Colors.blue;
      case 'Boarding':
        return Colors.green;
      case 'Training':
        return Colors.orange;
      case 'Pet Store':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
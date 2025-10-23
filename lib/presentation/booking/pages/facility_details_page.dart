import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('Back to Home'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigate to My Bookings page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false,
              );
              // Change tab to bookings
              // You might need to use a different navigation approach for this
            },
            child: const Text('View Bookings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facility Details'),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Facility Image
          Container(
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
          const SizedBox(height: 16),

          // Facility Name and Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  facility.name,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
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
          const SizedBox(height: 8),

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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                facility.distanceText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Description',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            facility.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Services
          Text(
            'Services',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: facility.services.map((service) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          const SizedBox(height: 24),

          // Contact Info
          Container(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 12),
                _buildContactItem(Icons.location_on, facility.address),
                const SizedBox(height: 8),
                _buildContactItem(Icons.phone, facility.phone),
                const SizedBox(height: 8),
                _buildContactItem(Icons.access_time, 'Hours: ${facility.hours}'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Booking Section
          Text(
            'Book an Appointment',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          // Pet Type Selector
          PetTypeSelector(
            selectedPetType: state.selectedPetType,
            onPetTypeSelected: (petType) {
              context.read<BookingBloc>().add(SelectPetTypeEvent(petType));
            },
          ),
          const SizedBox(height: 24),

          // Date Selector
          DateSelector(
            selectedDate: state.selectedDate,
            onDateSelected: (date) {
              context.read<BookingBloc>().add(SelectDateEvent(date));
            },
          ),
          const SizedBox(height: 24),

          // Time Slot Selector
          TimeSlotSelector(
            selectedTimeSlot: state.selectedTimeSlot,
            onTimeSlotSelected: (timeSlot) {
              context.read<BookingBloc>().add(SelectTimeSlotEvent(timeSlot));
            },
          ),
          const SizedBox(height: 32),

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
                        petType: (state as FacilityDetailsLoaded).selectedPetType,
                        date: state.selectedDate,
                        timeSlot: state.selectedTimeSlot,
                        price: facility.price,
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
                      ? const SizedBox(
                    width: 20,
                    height: 20,
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
          const SizedBox(height: 16),
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
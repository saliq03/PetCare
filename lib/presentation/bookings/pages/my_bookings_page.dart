import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bookings_bloc.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_bookings.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingsBloc>().add(LoadBookingsEvent());
  }

  void _showCancelConfirmationDialog(String bookingId, String facilityName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: Text('Are you sure you want to cancel your booking at $facilityName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookingsBloc>().add(CancelBookingEvent(bookingId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _showCancellationSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking cancelled successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToHome() {
    // Navigate to home page (you might need to adjust this based on your navigation structure)
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BookingsBloc>().add(RefreshBookingsEvent());
            },
          ),
        ],
      ),
      body: BlocListener<BookingsBloc, BookingsState>(
        listener: (context, state) {
          if (state is BookingCancelled) {
            _showCancellationSuccessSnackbar();
          }
        },
        child: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            if (state is BookingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookingsEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BookingsBloc>().add(RefreshBookingsEvent());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: EmptyBookings(onExploreFacilities: _navigateToHome),
                  ),
                ),
              );
            }

            if (state is BookingsError) {
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
                        context.read<BookingsBloc>().add(LoadBookingsEvent());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is BookingsLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BookingsBloc>().add(RefreshBookingsEvent());
                },
                child: CustomScrollView(
                  slivers: [
                    // Upcoming Bookings Section
                    if (state.upcomingBookings.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Upcoming Appointments',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (state.upcomingBookings.isNotEmpty)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final booking = state.upcomingBookings[index];
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                16,
                                index == 0 ? 0 : 8,
                                16,
                                index == state.upcomingBookings.length - 1 ? 16 : 8,
                              ),
                              child: BookingCard(
                                booking: booking,
                                showCancelButton: true,
                                onCancel: () => _showCancelConfirmationDialog(
                                  booking.id,
                                  booking.facilityName,
                                ),
                                onTap: () {
                                  // TODO: Navigate to booking details
                                },
                              ),
                            );
                          },
                          childCount: state.upcomingBookings.length,
                        ),
                      ),

                    // Past Bookings Section
                    if (state.pastBookings.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'Past Appointments',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (state.pastBookings.isNotEmpty)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final booking = state.pastBookings[index];
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                16,
                                index == 0 ? 0 : 8,
                                16,
                                index == state.pastBookings.length - 1 ? 16 : 8,
                              ),
                              child: BookingCard(
                                booking: booking,
                                showCancelButton: false,
                                onTap: () {
                                  // TODO: Navigate to booking details or facility
                                },
                              ),
                            );
                          },
                          childCount: state.pastBookings.length,
                        ),
                      ),

                    // Empty state if both are empty (shouldn't happen but safety)
                    if (state.upcomingBookings.isEmpty && state.pastBookings.isEmpty)
                      const SliverFillRemaining(
                        child: Center(
                          child: Text('No bookings found'),
                        ),
                      ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
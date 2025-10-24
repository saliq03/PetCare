import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/common/widgets/ui_helper.dart';
import 'package:petcare/core/config/constants/status.dart';

import '../bloc/bookings_bloc.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_bookings.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  void _showCancelConfirmationDialog(String bookingId, String facilityName,BuildContext context) {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title:  Text('Cancel Booking?',style: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600
        ),),
        content: Text('Are you sure you want to cancel your booking',
            style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400
            )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          TextButton(
          onPressed: () {
        Navigator.pop(context);
        // context.read<BookingsBloc>().add(CancelBookingEvent(bookingId));
        },
            child: const Text('Cancel Booking',style: TextStyle(color: Colors.red),),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => BookingsBloc()..add(LoadBookingsEvent()),
  child: Scaffold(
       backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title:  Text('My Bookings',style: GoogleFonts.inter(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
        ),),

      ),
      body: BlocBuilder<BookingsBloc, BookingsState>(
        builder: (context, state) {
          if (state.status==Status.loading || state.status==Status.initial) {
            return loadingWidget();
          }
          if (state.status==Status.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "Something went wrong",
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
          if (state.status ==Status.completed) {
            if (state.bookings.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BookingsBloc>().add(RefreshBookingsEvent());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: EmptyBookings(text: "No Bookings Yet",),
                  ),
                ),
              );
            }
            return DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.r),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Color(0xFF3F09AB),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black87,
                      dividerColor: Colors.transparent,

                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(fontWeight: FontWeight.w600),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Past'),
                      ],
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        // ------------------ ALL BOOKINGS ------------------
                        RefreshIndicator(
                          onRefresh: () async {
                            context.read<BookingsBloc>().add(RefreshBookingsEvent());
                          },
                          child:ListView.builder(
                            padding:EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
                            itemCount:state.bookings.length,
                            itemBuilder: (context, index) {
                              final allBookings = state.bookings;
                              final booking = allBookings[index];
                              return BookingCard(
                                booking: booking,
                                showCancelButton:
                                state.upcomingBookings.contains(booking),
                                onCancel: state.upcomingBookings.contains(booking)
                                    ? () => _showCancelConfirmationDialog(
                                  booking.id,
                                  booking.facilityName,
                                  context
                                )
                                    : null,
                                onTap: () {},
                              );
                            },
                          ),
                        ),

                        // ------------------ UPCOMING BOOKINGS ------------------
                        RefreshIndicator(
                          onRefresh: () async {
                            context.read<BookingsBloc>().add(RefreshBookingsEvent());
                          },
                          child: state.upcomingBookings.isEmpty
                              ? EmptyBookings(text: "No Upcoming Bookings ",)
                              : ListView.builder(
                            padding:EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
                            itemCount: state.upcomingBookings.length,
                            itemBuilder: (context, index) {
                              final booking = state.upcomingBookings[index];
                              return BookingCard(
                                booking: booking,
                                showCancelButton: true,
                                onCancel: () => _showCancelConfirmationDialog(
                                  booking.id,
                                  booking.facilityName,
                                  context
                                ),
                                onTap: () {},
                              );
                            },
                          ),
                        ),

                        // ------------------ PAST BOOKINGS ------------------
                        RefreshIndicator(
                          onRefresh: () async {
                            context.read<BookingsBloc>().add(RefreshBookingsEvent());
                          },
                          child: state.pastBookings.isEmpty
                              ? EmptyBookings(text: "No Past Bookings",)
                              : ListView.builder(
                            padding:EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
                            itemCount: state.pastBookings.length,
                            itemBuilder: (context, index) {
                              final booking = state.pastBookings[index];
                              return BookingCard(
                                booking: booking,
                                showCancelButton: false,
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );


          }
          return loadingWidget();


        },
      ),
    ),
);
  }

  Widget loadingWidget(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: UiHelper.shimmerWidget(width: 100, height: 30.h,borderRadius: 12.r)),
            SizedBox(width: 40.w,),
            Expanded(child: UiHelper.shimmerWidget(width: 130, height: 50.h,borderRadius: 12.r)),
            SizedBox(width: 40.w,),
            Expanded(child: UiHelper.shimmerWidget(width: 130, height: 50.h,borderRadius: 12.r)),


          ],),
          SizedBox(height: 20.h,),
          ListView.builder(
            itemCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: UiHelper.shimmerWidget(width: double.infinity, height: 200.h),
              );
            },
          )

        ],
      ),
    );
  }
}
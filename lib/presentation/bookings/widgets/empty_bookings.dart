import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyBookings extends StatelessWidget {
  final String text;

  const EmptyBookings({super.key,required this.text });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24.h),
          Text(
            text,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontSize: 30.sp
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You haven\'t made any bookings yet. Explore nearby facilities and book appointments for your pet.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          // const SizedBox(height: 32),
          // SizedBox(
          //   width: double.infinity,
          //   height: 50,
          //   child: ElevatedButton(
          //     onPressed: (){},
          //     // onExploreFacilities,
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Theme.of(context).primaryColor,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //     child: Text(
          //       'Explore Facilities',
          //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //         color: Colors.white,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 16),
          // TextButton(
          //   onPressed: () {
          //     // Refresh bookings
          //   },
          //   child: Text(
          //     'Refresh',
          //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //       color: Theme.of(context).primaryColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
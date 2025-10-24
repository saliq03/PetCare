import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/location_bloc.dart';

class LocationChip extends StatelessWidget {
  final VoidCallback onTap;

  const LocationChip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        String locationText = 'Select Location';
        bool isCurrentLocation = false;

        if (state is LocationLoaded) {
          locationText = state.selectedLocation;
          isCurrentLocation = state.isCurrentLocation;
        }

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              // border: Border.all(
              //   color: Colors.grey[400]!,
              //   width: 1,
              // ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // increase opacity
                  blurRadius: 12,                        // increase blur
                  spreadRadius: 1,                        // add spread
                  offset: const Offset(0, 4),             // make shadow drop more
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCurrentLocation ? Icons.my_location : Icons.location_on,
                  size: 16,
                  color: const Color(0xFF3F09AB),
                ),
                SizedBox(width: 6.w),
                Text(
                  locationText,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4.sp),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        );

      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCurrentLocation ? Icons.my_location : Icons.location_on,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  locationText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
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
import 'package:flutter/material.dart';

import '../../../data/models/time_slot_model.dart';

class TimeSlotSelector extends StatelessWidget {
  final String selectedTimeSlot;
  final Function(String) onTimeSlotSelected;

  const TimeSlotSelector({
    super.key,
    required this.selectedTimeSlot,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Morning Slots
        _buildTimeSlotSection(context, 'Morning', TimeSlot.morningSlots),
        const SizedBox(height: 20),

        // Afternoon Slots
        _buildTimeSlotSection(context, 'Afternoon', TimeSlot.afternoonSlots),
        const SizedBox(height: 20),

        // Evening Slots
        _buildTimeSlotSection(context, 'Evening', TimeSlot.eveningSlots),
      ],
    );
  }

  Widget _buildTimeSlotSection(BuildContext context, String title, List<TimeSlot> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final isSelected = slot.time == selectedTimeSlot;
            final isAvailable = slot.available;

            return GestureDetector(
              onTap: isAvailable ? () => onTimeSlotSelected(slot.time) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : isAvailable
                      ? Colors.white
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : isAvailable
                        ? Colors.grey[300]!
                        : Colors.grey[200]!,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  slot.time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : isAvailable
                        ? Colors.black
                        : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
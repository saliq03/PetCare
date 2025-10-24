import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/common/helpers/UserPrefrences.dart';
import 'package:petcare/core/config/constants/status.dart';
import 'package:petcare/dependency_injection.dart';
import 'package:petcare/presentation/auth/pages/login_page.dart';

import '../../../data/models/user_model.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/pet_card.dart';
import '../widgets/settings_item.dart';
import '../widgets/user_info_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              sL<UserPreferences>().removeUser();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LoginPage()),
                    (route) => false, );
           },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeletePetConfirmationDialog(
      String petId, String petName, BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Are you sure you want to delete $petName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              // Use parentContext to access the Bloc
              parentContext.read<ProfileBloc>().add(DeletePetEvent(petId));

              ScaffoldMessenger.of(parentContext).showSnackBar(
                SnackBar(content: Text('$petName deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfileEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.w700),
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == Status.initial || state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == Status.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Something Went Wrong",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfileEvent());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

           return RefreshIndicator(
              onRefresh: () async => context.read<ProfileBloc>().add(LoadProfileEvent()),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                children: [
                  UserInfoCard(
                    user: state.user!,
                    onEditProfile: () {
                      // Navigate to edit profile page if needed
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildPetsSection(context, state.user!),
                  const SizedBox(height: 24),
                  _buildSettingsSection(context),
                  const SizedBox(height: 24),
                  _buildAppInfoSection(context),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- PETS SECTION ----------------
  Widget _buildPetsSection(BuildContext context, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Pets',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 24.sp),
            ),
            TextButton.icon(
              onPressed: () {
                // Navigate to PetManagementPage to add a pet
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Pet'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (user.pets.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.pets, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No Pets Added',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your pets to manage their profiles and appointments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to PetManagementPage
                  },
                  child: const Text('Add Your First Pet'),
                ),
              ],
            ),
          )
        else
          Column(
            children: user.pets
                .map((pet) => PetCard(
              pet: pet,
              onEdit: () {
                // Navigate to PetManagementPage with pet
              },
              onDelete: () => _showDeletePetConfirmationDialog(pet.id, pet.name, context),
            ))
                .toList(),
          ),
      ],
    );
  }

  // ---------------- SETTINGS SECTION ----------------
  Widget _buildSettingsSection(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Card(
          child: Column(
            children: [
              SettingsItem(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Appointment reminders and updates',
                trailing: Switch(
                  value: state.notificationsEnabled,
                  onChanged: (_) => context.read<ProfileBloc>().add(ToggleNotificationsEvent()),
                ),
                onTap: () {},
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              SettingsItem(
                icon: Icons.security,
                title: 'Privacy & Security',
                onTap: () {},
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              SettingsItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              SettingsItem(
                icon: Icons.info_outline,
                title: 'About PetCare',
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- APP INFO SECTION ----------------
  Widget _buildAppInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.phone_android, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Version',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- LOGOUT BUTTON ----------------
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutConfirmationDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          'Logout',
          style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ---------------- ABOUT DIALOG ----------------
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About PetCare'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PetCare App',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Version: 1.0.0'),
            const SizedBox(height: 8),
            Text(
              'Your trusted companion for pet care services. Find the best veterinarians, groomers, and pet facilities near you.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

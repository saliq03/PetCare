import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petcare/presentation/profile/pages/pet_management_page.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/pet_card.dart';
import '../widgets/settings_item.dart';
import '../widgets/user_info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add( LoadProfileEvent());
    });
  }

  void _showLogoutConfirmationDialog() {
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
              // context.read<AuthBloc>().add(const LogoutEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeletePetConfirmationDialog(String petId, String petName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Are you sure you want to delete $petName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileBloc>().add(DeletePetEvent(petId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProfileBloc>().add(LoadProfileEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Handle specific state changes if needed
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
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
                      context.read<ProfileBloc>().add(LoadProfileEvent());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(LoadProfileEvent());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // User Info
                    UserInfoCard(
                      user: state.user,
                      onEditProfile: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BlocProvider.value(
                        //       value: context.read<ProfileBloc>(),
                        //       child: EditProfilePage(user: state.user),
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                    const SizedBox(height: 24),

                    // My Pets Section
                    _buildPetsSection(context, state),
                    const SizedBox(height: 24),

                    // Settings Section
                    _buildSettingsSection(context, state),
                    const SizedBox(height: 24),

                    // App Info Section
                    _buildAppInfoSection(context, state),
                    const SizedBox(height: 24),

                    // Logout Button
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPetsSection(BuildContext context, ProfileLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Pets',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => BlocProvider.value(
                //       value: context.read<ProfileBloc>(),
                //       child: const PetManagementPage(),
                //     ),
                //   ),
                // );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Pet'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.user.pets.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.pets,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No Pets Added',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your pets to manage their profiles and appointments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => BlocProvider.value(
                    //       value: context.read<ProfileBloc>(),
                    //       child: const PetManagementPage(),
                    //     ),
                    //   ),
                    // );
                  },
                  child: const Text('Add Your First Pet'),
                ),
              ],
            ),
          )
        else
          Column(
            children: state.user.pets.map((pet) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PetCard(
                  pet: pet,
                  onEdit: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => BlocProvider.value(
                    //       value: context.read<ProfileBloc>(),
                    //       child: PetManagementPage(pet: pet),
                    //     ),
                    //   ),
                    // );
                  },
                  onDelete: () => _showDeletePetConfirmationDialog(pet.id, pet.name),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, ProfileLoaded state) {
    return Card(
      child: Column(
        children: [
          SettingsItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Appointment reminders and updates',
            trailing: Switch(
              value: state.notificationsEnabled,
              onChanged: (value) {
                context.read<ProfileBloc>().add(ToggleNotificationsEvent(value));
              },
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          SettingsItem(
            icon: Icons.security,
            title: 'Privacy & Security',
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          const Divider(height: 1),
          SettingsItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // Navigate to help & support
            },
          ),
          const Divider(height: 1),
          SettingsItem(
            icon: Icons.info_outline,
            title: 'About PetCare',
            onTap: () {
              _showAboutDialog(context, state);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context, ProfileLoaded state) {
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  state.appVersion,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _showLogoutConfirmationDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Logout',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, ProfileLoaded state) {
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text('Version: ${state.appVersion}'),
            const SizedBox(height: 8),
            Text(
              'Your trusted companion for pet care services. Find the best veterinarians, groomers, and pet facilities near you.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
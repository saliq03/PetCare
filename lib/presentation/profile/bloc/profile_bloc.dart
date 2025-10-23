import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<AddPetEvent>(_onAddPet);
    on<EditPetEvent>(_onEditPet);
    on<DeletePetEvent>(_onDeletePet);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
  }

  FutureOr<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final user = _getDummyUser();
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(const ProfileError('Failed to load profile'));
    }
  }

  FutureOr<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      emit(ProfileLoading());

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      try {
        final currentState = state as ProfileLoaded;
        final updatedUser = User(
          id: currentState.user.id,
          name: event.name,
          phone: currentState.user.phone,
          email: event.email,
          profileImage: currentState.user.profileImage,
          joinedDate: currentState.user.joinedDate,
          pets: currentState.user.pets,
        );

        emit(ProfileLoaded(
          user: updatedUser,
          notificationsEnabled: currentState.notificationsEnabled,
          appVersion: currentState.appVersion,
        ));

        emit(ProfileUpdated(updatedUser));
      } catch (e) {
        emit(const ProfileError('Failed to update profile'));
      }
    }
  }

  FutureOr<void> _onAddPet(AddPetEvent event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedPets = List<Pet>.from(currentState.user.pets)..add(event.pet);

      final updatedUser = User(
        id: currentState.user.id,
        name: currentState.user.name,
        phone: currentState.user.phone,
        email: currentState.user.email,
        profileImage: currentState.user.profileImage,
        joinedDate: currentState.user.joinedDate,
        pets: updatedPets,
      );

      emit(currentState.copyWith(user: updatedUser));
      emit(PetAdded(updatedUser));
    }
  }

  FutureOr<void> _onEditPet(EditPetEvent event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedPets = currentState.user.pets.map((pet) {
        return pet.id == event.pet.id ? event.pet : pet;
      }).toList();

      final updatedUser = User(
        id: currentState.user.id,
        name: currentState.user.name,
        phone: currentState.user.phone,
        email: currentState.user.email,
        profileImage: currentState.user.profileImage,
        joinedDate: currentState.user.joinedDate,
        pets: updatedPets,
      );

      emit(currentState.copyWith(user: updatedUser));
      emit(PetUpdated(updatedUser));
    }
  }

  FutureOr<void> _onDeletePet(DeletePetEvent event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedPets = currentState.user.pets.where((pet) => pet.id != event.petId).toList();

      final updatedUser = User(
        id: currentState.user.id,
        name: currentState.user.name,
        phone: currentState.user.phone,
        email: currentState.user.email,
        profileImage: currentState.user.profileImage,
        joinedDate: currentState.user.joinedDate,
        pets: updatedPets,
      );

      emit(currentState.copyWith(user: updatedUser));
      emit(PetDeleted(updatedUser));
    }
  }

  FutureOr<void> _onToggleNotifications(ToggleNotificationsEvent event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(notificationsEnabled: event.enabled));
    }
  }

  User _getDummyUser() {
    return User(
      id: '1',
      name: 'Aarav Sharma',
      phone: '+91 9876543210',
      email: 'aarav.sharma@example.com',
      joinedDate: DateTime(2024, 1, 15),
      pets: [
        Pet(
          id: '1',
          name: 'Buddy',
          type: 'Dog',
          breed: 'Golden Retriever',
          birthDate: DateTime(2022, 5, 10),
          weight: 25.5,
          medicalNotes: ['Allergic to chicken', 'Annual vaccination due in Dec'],
        ),
        Pet(
          id: '2',
          name: 'Whiskers',
          type: 'Cat',
          breed: 'Persian',
          birthDate: DateTime(2023, 2, 20),
          weight: 4.2,
          medicalNotes: ['Indoor cat', 'Litter trained'],
        ),
      ],
    );
  }
}
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:petcare/core/config/constants/status.dart';

import '../../../data/models/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);

    on<DeletePetEvent>(_onDeletePet);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
  }

  FutureOr<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: Status.loading));

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final user = _getDummyUser();
      emit(state.copyWith(status: Status.completed,user: user));

    } catch (e) {
      emit(state.copyWith(status: Status.error));

    }
  }

 void _onDeletePet(DeletePetEvent event, Emitter<ProfileState> emit) {
    print(1);
    final currentUser = state.user;

    // Check if user and pets exist
    if (currentUser != null && currentUser.pets.isNotEmpty) {
      print(2);
      final updatedPets = List<Pet>.from(currentUser.pets)
        ..removeWhere((pet) => pet.id == event.petId);
      print(3);
      final updatedUser=User(
         id: currentUser.id,
         name: currentUser.name,
         phone: currentUser.phone,
         email: currentUser.email,
         joinedDate: currentUser.joinedDate,
         pets:updatedPets
       );
      print("deleted");
      emit(state.copyWith(user: updatedUser));
      print(6);
    }
  }


  void _onToggleNotifications(ToggleNotificationsEvent event, Emitter<ProfileState> emit) {
      emit(state.copyWith(notificationsEnabled: !state.notificationsEnabled));
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
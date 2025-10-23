part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;

  const UpdateProfileEvent({required this.name, required this.email});

  @override
  List<Object> get props => [name, email];
}

class AddPetEvent extends ProfileEvent {
  final Pet pet;

  const AddPetEvent(this.pet);

  @override
  List<Object> get props => [pet];
}

class EditPetEvent extends ProfileEvent {
  final Pet pet;

  const EditPetEvent(this.pet);

  @override
  List<Object> get props => [pet];
}

class DeletePetEvent extends ProfileEvent {
  final String petId;

  const DeletePetEvent(this.petId);

  @override
  List<Object> get props => [petId];
}

class ToggleNotificationsEvent extends ProfileEvent {
  final bool enabled;

  const ToggleNotificationsEvent(this.enabled);

  @override
  List<Object> get props => [enabled];
}
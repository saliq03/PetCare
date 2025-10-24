part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}


class DeletePetEvent extends ProfileEvent {
  final String petId;

  const DeletePetEvent(this.petId);

  @override
  List<Object> get props => [petId];
}

class ToggleNotificationsEvent extends ProfileEvent {}
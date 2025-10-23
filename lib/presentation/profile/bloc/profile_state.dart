part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final bool notificationsEnabled;
  final String appVersion;

  const ProfileLoaded({
    required this.user,
    this.notificationsEnabled = true,
    this.appVersion = '1.0.0',
  });

  @override
  List<Object> get props => [user, notificationsEnabled, appVersion];

  ProfileLoaded copyWith({
    User? user,
    bool? notificationsEnabled,
    String? appVersion,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}

class ProfileUpdated extends ProfileState {
  final User user;

  const ProfileUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class PetAdded extends ProfileState {
  final User user;

  const PetAdded(this.user);

  @override
  List<Object> get props => [user];
}

class PetUpdated extends ProfileState {
  final User user;

  const PetUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class PetDeleted extends ProfileState {
  final User user;

  const PetDeleted(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User? user;
  final bool notificationsEnabled;
  final Status status;

  const ProfileState({
    this.user,
    this.notificationsEnabled = true,
    this.status = Status.initial,
  });

  ProfileState copyWith({
    User? user,
    bool? notificationsEnabled,
    Status? status,
  }) {
    return ProfileState(
      user: user ?? this.user,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [user, notificationsEnabled, status];
}

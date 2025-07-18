// user_event.dart
part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class FetchUserEvent extends UserEvent {
  final String userId;

  const FetchUserEvent(this.userId);
}

class UpdateUserEvent extends UserEvent {
  final String userId;
  final UserModel user;

  const UpdateUserEvent(this.userId, this.user);
}

class UpdateProfilePictureEvent extends UserEvent {
  final String userId;
  final String profilePicture;

  const UpdateProfilePictureEvent(this.userId, this.profilePicture);
}

// user_state.dart
part of 'user_bloc.dart';
abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  
  const UserLoaded(this.user);
}

class UserUpdated extends UserState {
  final UserModel user;
  
  const UserUpdated(this.user);
}

class UserError extends UserState {
  final String message;
  
  const UserError(this.message);
}
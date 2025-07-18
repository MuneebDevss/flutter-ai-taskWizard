import 'package:task_wizard/Features/Auth/data/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wizard/Features/Profile/Domain/user_repository.dart';
part 'user_events.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(UserInitial()) {
    on<FetchUserEvent>(_onFetchUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<UpdateProfilePictureEvent>(_onUpdateProfilePicture);
  }

  Future<void> _onFetchUser(
    FetchUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await _userRepository.getUserData(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await _userRepository.updateUser(event.userId, event.user);
      emit(UserUpdated(event.user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePictureEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      emit(UserLoading());
      try {
        final updatedUser = currentUser.copyWith(
          profilePicture: event.profilePicture,
        );
        await _userRepository.updateUser(event.userId, updatedUser);
        emit(UserUpdated(updatedUser));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    }
  }
}

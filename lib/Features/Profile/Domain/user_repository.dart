
// ===== REPOSITORY LAYER =====

// user_repository.dart
import 'package:task_wizard/Features/Auth/data/user.dart';
import 'package:task_wizard/Features/Profile/Data/user_remote_data_source.dart';

class UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepository({required UserRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<UserModel> getUserData(String userId) async {
    try {
      return await _remoteDataSource.fetchUserData(userId);
    } catch (e) {
      throw Exception('Repository: Failed to get user data - $e');
    }
  }

  Future<void> updateUser(String userId, UserModel user) async {
    try {
      await _remoteDataSource.updateUserData(userId, user);
    } catch (e) {
      throw Exception('Repository: Failed to update user - $e');
    }
  }
}

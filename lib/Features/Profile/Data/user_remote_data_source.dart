import 'package:task_wizard/Features/Auth/data/user.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> fetchUserData(String userId);
  Future<void> updateUserData(String userId, UserModel user);
}

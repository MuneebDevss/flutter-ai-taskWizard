import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_wizard/Features/Auth/data/user.dart';
import 'package:task_wizard/Features/Profile/Data/user_remote_data_source.dart';

class UserFirebaseRemoteDataSource implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _usersCollection = 'User';

  UserFirebaseRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> fetchUserData(String userId) async {
    try {
      final doc =
          await _firestore.collection(_usersCollection).doc(userId).get();

      if (!doc.exists) {
        throw Exception('User not found');
      }

      final data = doc.data()!;
      data['id'] = doc.id; // Add document ID to the data

      return UserModel.fromMap(data);
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  @override
  Future<void> updateUserData(String userId, UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }
}
